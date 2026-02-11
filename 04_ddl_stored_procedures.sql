-- ============================================================================
-- SECTION 10: STORED PROCEDURES
-- ============================================================================

CREATE PROCEDURE ohc.sp_log_action
    @user_id INT,
    @action_type VARCHAR(50),
    @action_detail NVARCHAR(500) = NULL,
    @table_name VARCHAR(50) = NULL,
    @record_id INT = NULL,
    @ip_address VARCHAR(45) = NULL,
    @status VARCHAR(20) = 'success'
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO ohc.access_log (user_id, action_type, action_detail, table_name, record_id, ip_address, status)
    VALUES (@user_id, @action_type, @action_detail, @table_name, @record_id, @ip_address, @status);
END;
GO

CREATE PROCEDURE ohc.sp_record_failed_login
    @username VARCHAR(50),
    @ip_address VARCHAR(45) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @user_id INT;
    
    SELECT @user_id = user_id FROM ohc.user_account WHERE username = @username;
    
    IF @user_id IS NOT NULL
    BEGIN
        UPDATE ohc.user_account
        SET failed_attempts = failed_attempts + 1,
            is_locked = CASE WHEN failed_attempts + 1 >= 5 THEN 1 ELSE 0 END,
            updated_at = GETDATE()
        WHERE user_id = @user_id;
        
        EXEC ohc.sp_log_action @user_id, 'login_failed', N'Failed login attempt', NULL, NULL, @ip_address, 'failure';
    END
END;
GO

CREATE PROCEDURE ohc.sp_record_successful_login
    @user_id INT,
    @ip_address VARCHAR(45) = NULL,
    @user_agent VARCHAR(300) = NULL,
    @session_token VARCHAR(256) = NULL,
    @session_hours INT = 24
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE ohc.user_account
    SET failed_attempts = 0, last_login = GETDATE(), updated_at = GETDATE()
    WHERE user_id = @user_id;
    
    IF @session_token IS NOT NULL
    BEGIN
        INSERT INTO ohc.user_session (user_id, session_token, ip_address, user_agent, expires_at)
        VALUES (@user_id, @session_token, @ip_address, @user_agent, DATEADD(HOUR, @session_hours, GETDATE()));
    END
    
    EXEC ohc.sp_log_action @user_id, 'login_success', N'User logged in', NULL, NULL, @ip_address, 'success';
END;
GO

CREATE PROCEDURE ohc.sp_logout
    @session_token VARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @user_id INT;
    
    SELECT @user_id = user_id FROM ohc.user_session WHERE session_token = @session_token AND is_active = 1;
    
    IF @user_id IS NOT NULL
    BEGIN
        UPDATE ohc.user_session SET is_active = 0 WHERE session_token = @session_token;
        EXEC ohc.sp_log_action @user_id, 'logout', NULL, NULL, NULL, NULL, 'success';
    END
END;
GO

CREATE PROCEDURE ohc.sp_change_password
    @user_id INT,
    @new_password_hash VARCHAR(256),
    @check_history BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @check_history = 1 AND EXISTS (
        SELECT 1 FROM (
            SELECT TOP 5 password_hash FROM ohc.password_history 
            WHERE user_id = @user_id ORDER BY created_at DESC
        ) recent WHERE password_hash = @new_password_hash
    )
    BEGIN
        RAISERROR('Cannot reuse recent passwords.', 16, 1);
        RETURN;
    END
    
    INSERT INTO ohc.password_history (user_id, password_hash)
    SELECT user_id, password_hash FROM ohc.user_account WHERE user_id = @user_id;
    
    UPDATE ohc.user_account
    SET password_hash = @new_password_hash, password_changed_at = GETDATE(), updated_at = GETDATE()
    WHERE user_id = @user_id;
    
    EXEC ohc.sp_log_action @user_id, 'password_change', NULL, NULL, NULL, NULL, 'success';
END;
GO

CREATE PROCEDURE ohc.sp_check_permission
    @user_id INT,
    @required_role VARCHAR(30),
    @has_permission BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @has_permission = 0;
    
    IF EXISTS (
        SELECT 1
        FROM ohc.user_account ua
        INNER JOIN ohc.person_role pr ON ua.person_id = pr.person_id
        INNER JOIN ohc.role r ON pr.role_id = r.role_id
        WHERE ua.user_id = @user_id
          AND ua.is_active = 1 AND ua.is_locked = 0
          AND pr.is_active = 1 AND r.role_name = @required_role
    )
    SET @has_permission = 1;
END;
GO

CREATE PROCEDURE ohc.sp_create_medical_record
    @patient_id INT,
    @doctor_id INT,
    @appointment_id INT = NULL,
    @diagnosis NVARCHAR(500),
    @diagnosis_code VARCHAR(20) = NULL,
    @symptoms NVARCHAR(500) = NULL,
    @examination_notes NVARCHAR(MAX) = NULL,
    @treatment_plan NVARCHAR(MAX) = NULL,
    @follow_up_required BIT = 0,
    @follow_up_date DATE = NULL,
    @record_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        INSERT INTO ohc.medical_record (
            patient_id, doctor_id, appointment_id, diagnosis, diagnosis_code,
            symptoms, examination_notes, treatment_plan, follow_up_required, follow_up_date
        ) VALUES (
            @patient_id, @doctor_id, @appointment_id, @diagnosis, @diagnosis_code,
            @symptoms, @examination_notes, @treatment_plan, @follow_up_required, @follow_up_date
        );
        
        SET @record_id = SCOPE_IDENTITY();
        
        IF @appointment_id IS NOT NULL
            UPDATE ohc.appointment SET status = 'completed', updated_at = GETDATE()
            WHERE appointment_id = @appointment_id;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

CREATE PROCEDURE ohc.sp_add_prescription
    @record_id INT,
    @medicine_name NVARCHAR(100),
    @dosage NVARCHAR(100),
    @frequency NVARCHAR(50) = NULL,
    @duration_days INT = NULL,
    @quantity INT = NULL,
    @instructions NVARCHAR(300) = NULL,
    @refills_allowed INT = 0,
    @prescription_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @medicine_id INT;
    
    SELECT @medicine_id = medicine_id FROM ohc.medicine WHERE medicine_name = @medicine_name AND is_active = 1;
    
    INSERT INTO ohc.prescription (
        record_id, medicine_id, medicine_name, dosage, frequency,
        duration_days, quantity, instructions, refills_allowed
    ) VALUES (
        @record_id, @medicine_id, @medicine_name, @dosage, @frequency,
        @duration_days, @quantity, @instructions, @refills_allowed
    );
    
    SET @prescription_id = SCOPE_IDENTITY();
END;
GO

CREATE PROCEDURE ohc.sp_record_vitals
    @record_id INT,
    @bp_systolic INT = NULL,
    @bp_diastolic INT = NULL,
    @heart_rate INT = NULL,
    @temperature DECIMAL(4,1) = NULL,
    @respiratory_rate INT = NULL,
    @oxygen_saturation INT = NULL,
    @weight_kg DECIMAL(5,2) = NULL,
    @height_cm DECIMAL(5,2) = NULL,
    @notes NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO ohc.vital_signs (
        record_id, blood_pressure_sys, blood_pressure_dia, heart_rate,
        temperature, respiratory_rate, oxygen_saturation, weight_kg, height_cm, notes
    ) VALUES (
        @record_id, @bp_systolic, @bp_diastolic, @heart_rate,
        @temperature, @respiratory_rate, @oxygen_saturation, @weight_kg, @height_cm, @notes
    );
END;
GO

CREATE PROCEDURE ohc.sp_get_patient_history
    @patient_id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT * FROM ohc.v_patient_full WHERE person_id = @patient_id;
    
    SELECT record_id, diagnosis, diagnosis_code, symptoms, treatment_plan,
           pd.first_name + N' ' + pd.last_name AS doctor_name, dd.specialization, mr.created_at
    FROM ohc.medical_record mr
    INNER JOIN ohc.person pd ON mr.doctor_id = pd.person_id
    INNER JOIN ohc.doctor_details dd ON pd.person_id = dd.person_id
    WHERE mr.patient_id = @patient_id ORDER BY mr.created_at DESC;
    
    SELECT rx.medicine_name, rx.dosage, rx.frequency, rx.duration_days, rx.instructions,
           rx.refills_allowed - rx.refills_used AS refills_remaining, rx.created_at
    FROM ohc.prescription rx
    INNER JOIN ohc.medical_record mr ON rx.record_id = mr.record_id
    WHERE mr.patient_id = @patient_id AND rx.is_active = 1 ORDER BY rx.created_at DESC;
    
    SELECT TOP 10 blood_pressure_sys, blood_pressure_dia, heart_rate, temperature, weight_kg, measured_at
    FROM ohc.vital_signs vs
    INNER JOIN ohc.medical_record mr ON vs.record_id = mr.record_id
    WHERE mr.patient_id = @patient_id ORDER BY vs.measured_at DESC;
END;
GO

CREATE PROCEDURE ohc.sp_cleanup_expired_sessions
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE ohc.user_session SET is_active = 0 WHERE is_active = 1 AND expires_at < GETDATE();
    DELETE FROM ohc.user_session WHERE is_active = 0 AND created_at < DATEADD(DAY, -30, GETDATE());
END;
GO

CREATE PROCEDURE ohc.sp_cleanup_old_logs
    @days_to_keep INT = 365
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM ohc.access_log WHERE created_at < DATEADD(DAY, -@days_to_keep, GETDATE());
END;
GO
