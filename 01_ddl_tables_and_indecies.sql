-- ============================================================================
-- ONLINE HEALTHCARE APPOINTMENT & RECORDS SYSTEM
-- Complete Database Schema (FIXED)
-- ============================================================================
-- DBMS: SQL Server
-- Version: 1.1 (Fixed)
-- ============================================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'OnlineHealthCare')
BEGIN
    ALTER DATABASE OnlineHealthCare SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE OnlineHealthCare;
END
GO

-- Create with Ukrainian collation for proper character support
CREATE DATABASE OnlineHealthCare
COLLATE Ukrainian_CI_AS;
GO

USE OnlineHealthCare;
GO

CREATE SCHEMA ohc;
GO

-- ============================================================================
-- SECTION 1: CORE PERSON & ROLE TABLES
-- ============================================================================

CREATE TABLE ohc.person(
    person_id       INT IDENTITY(1,1),
    first_name      NVARCHAR(50) NOT NULL,          -- NVARCHAR for Unicode
    last_name       NVARCHAR(50) NOT NULL,          -- NVARCHAR for Unicode
    date_of_birth   DATE NOT NULL,
    gender          VARCHAR(20) NOT NULL,
    created_at      DATETIME2 DEFAULT GETDATE(),
    updated_at      DATETIME2 DEFAULT GETDATE(),
    is_active       BIT DEFAULT 1,
    
    CONSTRAINT pk_person PRIMARY KEY (person_id),
    CONSTRAINT ck_person_dob CHECK (date_of_birth <= GETDATE()),
    CONSTRAINT ck_person_dob_reasonable CHECK (date_of_birth >= '1900-01-01'),
    CONSTRAINT ck_person_gender CHECK (gender IN ('Male', 'Female', 'Other'))
);
GO

CREATE TABLE ohc.role(
    role_id         INT IDENTITY(1,1),
    role_name       VARCHAR(30) NOT NULL,
    description     NVARCHAR(200),
    created_at      DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_role PRIMARY KEY (role_id),
    CONSTRAINT uq_role_name UNIQUE (role_name)
);
GO

INSERT INTO ohc.role (role_name, description) VALUES
    ('patient', N'A person receiving medical care'),
    ('doctor', N'A licensed medical practitioner'),
    ('admin', N'System administrator'),
    ('nurse', N'Medical support staff'),
    ('receptionist', N'Front desk staff');
GO

CREATE TABLE ohc.person_role(
    person_id       INT NOT NULL,
    role_id         INT NOT NULL,
    assigned_at     DATETIME2 DEFAULT GETDATE(),
    assigned_by     INT,
    is_active       BIT DEFAULT 1,
    notes           NVARCHAR(200),
    
    CONSTRAINT pk_person_role PRIMARY KEY (person_id, role_id),
    CONSTRAINT fk_pr_person FOREIGN KEY (person_id) 
        REFERENCES ohc.person(person_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_pr_role FOREIGN KEY (role_id) 
        REFERENCES ohc.role(role_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_pr_assigned_by FOREIGN KEY (assigned_by)
        REFERENCES ohc.person(person_id)
        ON DELETE NO ACTION                         -- FIXED: was SET NULL
);
GO

-- ============================================================================
-- SECTION 2: CONTACT INFORMATION
-- ============================================================================

CREATE TABLE ohc.contact(
    contact_id      INT IDENTITY(1,1),
    person_id       INT NOT NULL,
    contact_type    VARCHAR(20) NOT NULL,
    contact_value   NVARCHAR(150) NOT NULL,
    context         VARCHAR(20) NOT NULL,
    is_primary      BIT DEFAULT 0,
    is_verified     BIT DEFAULT 0,
    created_at      DATETIME2 DEFAULT GETDATE(),
    updated_at      DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_contact PRIMARY KEY (contact_id),
    CONSTRAINT fk_contact_person FOREIGN KEY (person_id) 
        REFERENCES ohc.person(person_id)
        ON DELETE CASCADE,
    CONSTRAINT uq_contact_type_value UNIQUE (contact_type, contact_value),
    CONSTRAINT ck_contact_type CHECK (contact_type IN ('email', 'phone', 'fax')),
    CONSTRAINT ck_contact_context CHECK (context IN ('personal', 'professional', 'emergency')),
    CONSTRAINT ck_email_format CHECK (
        contact_type != 'email' 
        OR (contact_value LIKE '%_@_%._%' AND contact_value NOT LIKE '% %')
    )
);
GO

CREATE INDEX ix_contact_person ON ohc.contact(person_id);
GO

CREATE TABLE ohc.address(
    address_id      INT IDENTITY(1,1),
    person_id       INT NOT NULL,
    address_type    VARCHAR(20) NOT NULL,
    address_line1   NVARCHAR(100) NOT NULL,
    address_line2   NVARCHAR(100),
    city            NVARCHAR(50) NOT NULL,
    region          NVARCHAR(50),
    postal_code     VARCHAR(20),
    country         NVARCHAR(50) NOT NULL DEFAULT N'Ukraine',
    is_primary      BIT DEFAULT 0,
    created_at      DATETIME2 DEFAULT GETDATE(),
    updated_at      DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_address PRIMARY KEY (address_id),
    CONSTRAINT fk_address_person FOREIGN KEY (person_id) 
        REFERENCES ohc.person(person_id)
        ON DELETE CASCADE,
    CONSTRAINT ck_address_type CHECK (address_type IN ('home', 'work', 'billing', 'mailing'))
);
GO

CREATE INDEX ix_address_person ON ohc.address(person_id);
GO

-- ============================================================================
-- SECTION 3: ROLE-SPECIFIC DETAILS
-- ============================================================================

CREATE TABLE ohc.patient_details(
    person_id           INT NOT NULL,
    blood_type          VARCHAR(5),
    allergies           NVARCHAR(500),
    medical_conditions  NVARCHAR(500),
    emergency_contact   NVARCHAR(100),
    emergency_phone     VARCHAR(20),
    insurance_provider  NVARCHAR(100),
    insurance_number    VARCHAR(50),
    notes               NVARCHAR(MAX),
    created_at          DATETIME2 DEFAULT GETDATE(),
    updated_at          DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_patient_details PRIMARY KEY (person_id),
    CONSTRAINT fk_pd_person FOREIGN KEY (person_id) 
        REFERENCES ohc.person(person_id)
        ON DELETE CASCADE,
    CONSTRAINT ck_blood_type CHECK (
        blood_type IS NULL 
        OR blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')
    )
);
GO

CREATE TABLE ohc.doctor_details(
    person_id               INT NOT NULL,
    specialization          NVARCHAR(100) NOT NULL,
    license_number          VARCHAR(30) NOT NULL,
    license_expiry          DATE,
    years_of_experience     INT NOT NULL DEFAULT 0,
    qualification           NVARCHAR(200),
    bio                     NVARCHAR(MAX),
    created_at              DATETIME2 DEFAULT GETDATE(),
    updated_at              DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_doctor_details PRIMARY KEY (person_id),
    CONSTRAINT fk_dd_person FOREIGN KEY (person_id) 
        REFERENCES ohc.person(person_id)
        ON DELETE CASCADE,
    CONSTRAINT uq_license_number UNIQUE (license_number),
    CONSTRAINT ck_experience CHECK (years_of_experience >= 0)
);
GO

-- ============================================================================
-- SECTION 4: CLINIC & DOCTOR-CLINIC RELATIONSHIP
-- ============================================================================

CREATE TABLE ohc.clinic(
    clinic_id       INT IDENTITY(1,1),
    clinic_name     NVARCHAR(100) NOT NULL,
    clinic_type     VARCHAR(50),
    city            NVARCHAR(50) NOT NULL,
    address         NVARCHAR(150) NOT NULL,
    phone           VARCHAR(20),
    email           VARCHAR(100),
    website         VARCHAR(150),
    operating_hours NVARCHAR(200),
    is_active       BIT DEFAULT 1,
    created_at      DATETIME2 DEFAULT GETDATE(),
    updated_at      DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_clinic PRIMARY KEY (clinic_id),
    CONSTRAINT ck_clinic_email CHECK (
        email IS NULL 
        OR (email LIKE '%_@_%._%' AND email NOT LIKE '% %')
    )
);
GO

CREATE TABLE ohc.doctor_clinic(
    doctor_clinic_id    INT IDENTITY(1,1),
    doctor_id           INT NOT NULL,
    clinic_id           INT NOT NULL,
    day_of_week         TINYINT NOT NULL,
    start_time          TIME NOT NULL,
    end_time            TIME NOT NULL,
    is_active           BIT DEFAULT 1,
    created_at          DATETIME2 DEFAULT GETDATE(),
    updated_at          DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_doctor_clinic PRIMARY KEY (doctor_clinic_id),
    CONSTRAINT uq_doctor_clinic_day UNIQUE (doctor_id, clinic_id, day_of_week),
    CONSTRAINT fk_dc_doctor FOREIGN KEY (doctor_id) 
        REFERENCES ohc.person(person_id),
    CONSTRAINT fk_dc_clinic FOREIGN KEY (clinic_id) 
        REFERENCES ohc.clinic(clinic_id)
        ON DELETE CASCADE,
    CONSTRAINT ck_day_of_week CHECK (day_of_week BETWEEN 1 AND 7),
    CONSTRAINT ck_time_order CHECK (end_time > start_time)
);
GO

CREATE INDEX ix_dc_doctor ON ohc.doctor_clinic(doctor_id);
CREATE INDEX ix_dc_clinic ON ohc.doctor_clinic(clinic_id);
GO

-- ============================================================================
-- SECTION 5: APPOINTMENTS
-- ============================================================================

CREATE TABLE ohc.appointment(
    appointment_id      INT IDENTITY(1,1),
    patient_id          INT NOT NULL,
    doctor_id           INT NOT NULL,
    clinic_id           INT NOT NULL,
    appointment_start   DATETIME2 NOT NULL,
    appointment_end     DATETIME2 NOT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'scheduled',
    reason              NVARCHAR(300),
    notes               NVARCHAR(500),
    created_at          DATETIME2 DEFAULT GETDATE(),
    updated_at          DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_appointment PRIMARY KEY (appointment_id),
    CONSTRAINT fk_apt_patient FOREIGN KEY (patient_id) 
        REFERENCES ohc.person(person_id),
    CONSTRAINT fk_apt_doctor FOREIGN KEY (doctor_id) 
        REFERENCES ohc.person(person_id),
    CONSTRAINT fk_apt_clinic FOREIGN KEY (clinic_id) 
        REFERENCES ohc.clinic(clinic_id),
    CONSTRAINT ck_apt_time_order CHECK (appointment_end > appointment_start),
    CONSTRAINT ck_apt_status CHECK (status IN (
        'scheduled', 
        'confirmed', 
        'in_progress', 
        'completed', 
        'cancelled', 
        'no_show'
    )),
    CONSTRAINT ck_apt_duration CHECK (
        DATEDIFF(MINUTE, appointment_start, appointment_end) BETWEEN 10 AND 180
    )
);
GO

CREATE INDEX ix_apt_doctor_time ON ohc.appointment(doctor_id, appointment_start, appointment_end);
CREATE INDEX ix_apt_patient ON ohc.appointment(patient_id);
CREATE INDEX ix_apt_clinic_date ON ohc.appointment(clinic_id, appointment_start);
-- FIXED: Use positive IN list instead of NOT IN
CREATE INDEX ix_apt_status ON ohc.appointment(status) 
    WHERE status IN ('scheduled', 'confirmed', 'in_progress', 'no_show');
GO

-- ============================================================================
-- SECTION 6: USERS & SECURITY
-- ============================================================================

CREATE TABLE ohc.user_account(
    user_id             INT IDENTITY(1,1),
    person_id           INT NOT NULL,
    username            VARCHAR(50) NOT NULL,
    password_hash       VARCHAR(256) NOT NULL,
    email               VARCHAR(100) NOT NULL,
    is_active           BIT DEFAULT 1,
    is_locked           BIT DEFAULT 0,
    failed_attempts     INT DEFAULT 0,
    last_login          DATETIME2,
    password_changed_at DATETIME2 DEFAULT GETDATE(),
    created_at          DATETIME2 DEFAULT GETDATE(),
    updated_at          DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_user_account PRIMARY KEY (user_id),
    CONSTRAINT fk_ua_person FOREIGN KEY (person_id) 
        REFERENCES ohc.person(person_id)
        ON DELETE CASCADE,
    CONSTRAINT uq_username UNIQUE (username),
    CONSTRAINT uq_user_email UNIQUE (email),
    CONSTRAINT uq_user_person UNIQUE (person_id),
    CONSTRAINT ck_username_length CHECK (LEN(username) >= 4),
    CONSTRAINT ck_username_format CHECK (username NOT LIKE '% %'),
    CONSTRAINT ck_failed_attempts CHECK (failed_attempts >= 0)
);
GO

CREATE INDEX ix_user_username ON ohc.user_account(username) WHERE is_active = 1;
CREATE INDEX ix_user_email ON ohc.user_account(email) WHERE is_active = 1;
GO

CREATE TABLE ohc.access_log(
    log_id              BIGINT IDENTITY(1,1),
    user_id             INT,
    action_type         VARCHAR(50) NOT NULL,
    action_detail       NVARCHAR(500),
    table_name          VARCHAR(50),
    record_id           INT,
    ip_address          VARCHAR(45),
    user_agent          VARCHAR(300),
    status              VARCHAR(20) DEFAULT 'success',
    created_at          DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_access_log PRIMARY KEY (log_id),
    CONSTRAINT fk_al_user FOREIGN KEY (user_id) 
        REFERENCES ohc.user_account(user_id)
        ON DELETE SET NULL,
    CONSTRAINT ck_log_status CHECK (status IN ('success', 'failure', 'warning'))
);
GO

CREATE INDEX ix_log_user ON ohc.access_log(user_id, created_at DESC);
CREATE INDEX ix_log_action ON ohc.access_log(action_type, created_at DESC);
CREATE INDEX ix_log_date ON ohc.access_log(created_at DESC);
CREATE INDEX ix_log_table ON ohc.access_log(table_name, record_id);
GO

CREATE TABLE ohc.user_session(
    session_id          INT IDENTITY(1,1),
    user_id             INT NOT NULL,
    session_token       VARCHAR(256) NOT NULL,
    ip_address          VARCHAR(45),
    user_agent          VARCHAR(300),
    created_at          DATETIME2 DEFAULT GETDATE(),
    expires_at          DATETIME2 NOT NULL,
    is_active           BIT DEFAULT 1,
    
    CONSTRAINT pk_user_session PRIMARY KEY (session_id),
    CONSTRAINT fk_us_user FOREIGN KEY (user_id) 
        REFERENCES ohc.user_account(user_id)
        ON DELETE CASCADE,
    CONSTRAINT uq_session_token UNIQUE (session_token)
);
GO

CREATE INDEX ix_session_token ON ohc.user_session(session_token) WHERE is_active = 1;
CREATE INDEX ix_session_user ON ohc.user_session(user_id, is_active);
CREATE INDEX ix_session_expiry ON ohc.user_session(expires_at) WHERE is_active = 1;
GO

CREATE TABLE ohc.password_history(
    history_id          INT IDENTITY(1,1),
    user_id             INT NOT NULL,
    password_hash       VARCHAR(256) NOT NULL,
    created_at          DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_password_history PRIMARY KEY (history_id),
    CONSTRAINT fk_ph_user FOREIGN KEY (user_id) 
        REFERENCES ohc.user_account(user_id)
        ON DELETE CASCADE
);
GO

CREATE INDEX ix_ph_user ON ohc.password_history(user_id, created_at DESC);
GO

-- ============================================================================
-- SECTION 7: MEDICAL RECORDS & PRESCRIPTIONS
-- ============================================================================

CREATE TABLE ohc.medical_record(
    record_id           INT IDENTITY(1,1),
    patient_id          INT NOT NULL,
    doctor_id           INT NOT NULL,
    appointment_id      INT,
    diagnosis           NVARCHAR(500) NOT NULL,
    diagnosis_code      VARCHAR(20),
    symptoms            NVARCHAR(500),
    examination_notes   NVARCHAR(MAX),
    treatment_plan      NVARCHAR(MAX),
    follow_up_required  BIT DEFAULT 0,
    follow_up_date      DATE,
    is_confidential     BIT DEFAULT 0,
    created_at          DATETIME2 DEFAULT GETDATE(),
    updated_at          DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_medical_record PRIMARY KEY (record_id),
    CONSTRAINT fk_mr_patient FOREIGN KEY (patient_id) 
        REFERENCES ohc.person(person_id),
    CONSTRAINT fk_mr_doctor FOREIGN KEY (doctor_id) 
        REFERENCES ohc.person(person_id),
    CONSTRAINT fk_mr_appointment FOREIGN KEY (appointment_id) 
        REFERENCES ohc.appointment(appointment_id),
    CONSTRAINT ck_followup_date CHECK (
        follow_up_date IS NULL 
        OR follow_up_date >= '2020-01-01'
    )
);
GO

CREATE INDEX ix_mr_patient ON ohc.medical_record(patient_id, created_at DESC);
CREATE INDEX ix_mr_doctor ON ohc.medical_record(doctor_id, created_at DESC);
CREATE INDEX ix_mr_appointment ON ohc.medical_record(appointment_id);
CREATE INDEX ix_mr_diagnosis_code ON ohc.medical_record(diagnosis_code);
GO

CREATE TABLE ohc.medicine(
    medicine_id             INT IDENTITY(1,1),
    medicine_name           NVARCHAR(100) NOT NULL,
    generic_name            NVARCHAR(100),
    category                VARCHAR(50),
    form                    VARCHAR(30),
    strength                VARCHAR(30),
    manufacturer            NVARCHAR(100),
    requires_prescription   BIT DEFAULT 1,
    notes                   NVARCHAR(300),
    is_active               BIT DEFAULT 1,
    created_at              DATETIME2 DEFAULT GETDATE(),
    updated_at              DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_medicine PRIMARY KEY (medicine_id),
    CONSTRAINT uq_medicine_name_strength UNIQUE (medicine_name, strength),
    CONSTRAINT ck_medicine_form CHECK (form IN (
        'tablet', 'capsule', 'syrup', 'injection', 
        'cream', 'ointment', 'drops', 'inhaler', 'patch', 'other'
    ))
);
GO

CREATE TABLE ohc.prescription(
    prescription_id     INT IDENTITY(1,1),
    record_id           INT NOT NULL,
    medicine_id         INT,
    medicine_name       NVARCHAR(100) NOT NULL,
    dosage              NVARCHAR(100) NOT NULL,
    frequency           NVARCHAR(50),
    duration_days       INT,
    quantity            INT,
    instructions        NVARCHAR(300),
    refills_allowed     INT DEFAULT 0,
    refills_used        INT DEFAULT 0,
    is_active           BIT DEFAULT 1,
    created_at          DATETIME2 DEFAULT GETDATE(),
    updated_at          DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_prescription PRIMARY KEY (prescription_id),
    CONSTRAINT fk_rx_record FOREIGN KEY (record_id) 
        REFERENCES ohc.medical_record(record_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_rx_medicine FOREIGN KEY (medicine_id) 
        REFERENCES ohc.medicine(medicine_id),
    CONSTRAINT ck_duration CHECK (duration_days IS NULL OR duration_days > 0),
    CONSTRAINT ck_quantity CHECK (quantity IS NULL OR quantity > 0),
    CONSTRAINT ck_refills CHECK (refills_used <= refills_allowed)
);
GO

CREATE INDEX ix_rx_record ON ohc.prescription(record_id);
CREATE INDEX ix_rx_medicine ON ohc.prescription(medicine_id);
GO

CREATE TABLE ohc.vital_signs(
    vital_id            INT IDENTITY(1,1),
    record_id           INT NOT NULL,
    blood_pressure_sys  INT,
    blood_pressure_dia  INT,
    heart_rate          INT,
    temperature         DECIMAL(4,1),
    respiratory_rate    INT,
    oxygen_saturation   INT,
    weight_kg           DECIMAL(5,2),
    height_cm           DECIMAL(5,2),
    notes               NVARCHAR(200),
    measured_at         DATETIME2 DEFAULT GETDATE(),
    created_at          DATETIME2 DEFAULT GETDATE(),
    updated_at          DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_vital_signs PRIMARY KEY (vital_id),
    CONSTRAINT fk_vs_record FOREIGN KEY (record_id) 
        REFERENCES ohc.medical_record(record_id)
        ON DELETE CASCADE,
    CONSTRAINT ck_bp_sys CHECK (blood_pressure_sys IS NULL OR blood_pressure_sys BETWEEN 50 AND 300),
    CONSTRAINT ck_bp_dia CHECK (blood_pressure_dia IS NULL OR blood_pressure_dia BETWEEN 30 AND 200),
    CONSTRAINT ck_heart_rate CHECK (heart_rate IS NULL OR heart_rate BETWEEN 20 AND 300),
    CONSTRAINT ck_temperature CHECK (temperature IS NULL OR temperature BETWEEN 30.0 AND 45.0),
    CONSTRAINT ck_respiratory CHECK (respiratory_rate IS NULL OR respiratory_rate BETWEEN 5 AND 60),
    CONSTRAINT ck_oxygen CHECK (oxygen_saturation IS NULL OR oxygen_saturation BETWEEN 50 AND 100),
    CONSTRAINT ck_weight CHECK (weight_kg IS NULL OR weight_kg BETWEEN 0.5 AND 500),
    CONSTRAINT ck_height CHECK (height_cm IS NULL OR height_cm BETWEEN 20 AND 300)
);
GO

CREATE INDEX ix_vs_record ON ohc.vital_signs(record_id);
GO

CREATE TABLE ohc.lab_result(
    result_id           INT IDENTITY(1,1),
    record_id           INT NOT NULL,
    test_name           NVARCHAR(100) NOT NULL,
    test_code           VARCHAR(20),
    result_value        NVARCHAR(50) NOT NULL,
    unit                VARCHAR(20),
    reference_range     VARCHAR(50),
    is_abnormal         BIT DEFAULT 0,
    notes               NVARCHAR(200),
    tested_at           DATETIME2,
    created_at          DATETIME2 DEFAULT GETDATE(),
    updated_at          DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT pk_lab_result PRIMARY KEY (result_id),
    CONSTRAINT fk_lr_record FOREIGN KEY (record_id) 
        REFERENCES ohc.medical_record(record_id)
        ON DELETE CASCADE
);
GO

CREATE INDEX ix_lab_record ON ohc.lab_result(record_id);
CREATE INDEX ix_lab_test ON ohc.lab_result(test_name);
GO


