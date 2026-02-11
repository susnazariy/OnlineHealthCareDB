-- ============================================================================
-- SECTION 9: TRIGGERS
-- ============================================================================

CREATE TRIGGER ohc.trg_prevent_doctor_overlap
ON ohc.appointment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN ohc.appointment a ON i.doctor_id = a.doctor_id
        WHERE a.appointment_id != i.appointment_id
          AND a.status NOT IN ('cancelled', 'no_show')
          AND i.status NOT IN ('cancelled', 'no_show')
          AND i.appointment_start < a.appointment_end
          AND i.appointment_end > a.appointment_start
    )
    BEGIN
        RAISERROR('Doctor already has an appointment during this time slot.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

CREATE TRIGGER ohc.trg_validate_doctor_clinic
ON ohc.appointment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    SET DATEFIRST 1;
    
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.status NOT IN ('cancelled')
          AND NOT EXISTS (
            SELECT 1
            FROM ohc.doctor_clinic dc
            WHERE dc.doctor_id = i.doctor_id
              AND dc.clinic_id = i.clinic_id
              AND dc.day_of_week = DATEPART(WEEKDAY, i.appointment_start)
              AND dc.is_active = 1
              AND CAST(i.appointment_start AS TIME) >= dc.start_time
              AND CAST(i.appointment_end AS TIME) <= dc.end_time
        )
    )
    BEGIN
        RAISERROR('Doctor does not work at this clinic on this day/time.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

CREATE TRIGGER ohc.trg_validate_appointment_roles
ON ohc.appointment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE NOT EXISTS (
            SELECT 1
            FROM ohc.person_role pr
            INNER JOIN ohc.role r ON pr.role_id = r.role_id
            WHERE pr.person_id = i.patient_id
              AND r.role_name = 'patient'
              AND pr.is_active = 1
        )
    )
    BEGIN
        RAISERROR('Invalid patient: person does not have patient role.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE NOT EXISTS (
            SELECT 1
            FROM ohc.person_role pr
            INNER JOIN ohc.role r ON pr.role_id = r.role_id
            WHERE pr.person_id = i.doctor_id
              AND r.role_name = 'doctor'
              AND pr.is_active = 1
        )
    )
    BEGIN
        RAISERROR('Invalid doctor: person does not have doctor role.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

CREATE TRIGGER ohc.trg_validate_medical_record_roles
ON ohc.medical_record
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (
        SELECT 1 FROM inserted i
        WHERE NOT EXISTS (
            SELECT 1 FROM ohc.person_role pr
            INNER JOIN ohc.role r ON pr.role_id = r.role_id
            WHERE pr.person_id = i.patient_id 
              AND r.role_name = 'patient' 
              AND pr.is_active = 1
        )
    )
    BEGIN
        RAISERROR('Invalid patient: person does not have patient role.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    IF EXISTS (
        SELECT 1 FROM inserted i
        WHERE NOT EXISTS (
            SELECT 1 FROM ohc.person_role pr
            INNER JOIN ohc.role r ON pr.role_id = r.role_id
            WHERE pr.person_id = i.doctor_id 
              AND r.role_name = 'doctor' 
              AND pr.is_active = 1
        )
    )
    BEGIN
        RAISERROR('Invalid doctor: person does not have doctor role.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

CREATE TRIGGER ohc.trg_person_updated_at
ON ohc.person
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE ohc.person
    SET updated_at = GETDATE()
    WHERE person_id IN (SELECT person_id FROM inserted);
END;
GO

CREATE TRIGGER ohc.trg_appointment_updated_at
ON ohc.appointment
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE ohc.appointment
    SET updated_at = GETDATE()
    WHERE appointment_id IN (SELECT appointment_id FROM inserted);
END;
GO

CREATE TRIGGER ohc.trg_medical_record_updated_at
ON ohc.medical_record
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE ohc.medical_record
    SET updated_at = GETDATE()
    WHERE record_id IN (SELECT record_id FROM inserted);
END;
GO

CREATE TRIGGER ohc.trg_log_appointment_changes
ON ohc.appointment
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO ohc.access_log (action_type, action_detail, table_name, record_id)
    SELECT 'appointment_created', N'New appointment scheduled', 'appointment', appointment_id
    FROM inserted
    WHERE NOT EXISTS (SELECT 1 FROM deleted);
    
    INSERT INTO ohc.access_log (action_type, action_detail, table_name, record_id)
    SELECT 'appointment_updated', N'Status: ' + i.status, 'appointment', i.appointment_id
    FROM inserted i
    INNER JOIN deleted d ON i.appointment_id = d.appointment_id;
    
    INSERT INTO ohc.access_log (action_type, action_detail, table_name, record_id)
    SELECT 'appointment_deleted', N'Appointment removed', 'appointment', appointment_id
    FROM deleted
    WHERE NOT EXISTS (SELECT 1 FROM inserted);
END;
GO