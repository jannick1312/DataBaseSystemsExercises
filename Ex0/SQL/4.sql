BEGIN;

DROP TABLE IF EXISTS is_assigned       CASCADE;
DROP TABLE IF EXISTS is_prescribed     CASCADE;
DROP TABLE IF EXISTS appointment       CASCADE;
DROP TABLE IF EXISTS bill              CASCADE;
DROP TABLE IF EXISTS stay              CASCADE;
DROP TABLE IF EXISTS room              CASCADE;
DROP TABLE IF EXISTS time_treatment    CASCADE;
DROP TABLE IF EXISTS treatment         CASCADE;
DROP TABLE IF EXISTS patient           CASCADE;
DROP TABLE IF EXISTS doctor            CASCADE;
DROP TABLE IF EXISTS person            CASCADE;

CREATE TABLE person (
    id                   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name                 TEXT        NOT NULL,
    contact_information  TEXT        NOT NULL,
    birthday             DATE        NOT NULL
);

CREATE TABLE doctor (
    id                   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name                 TEXT        NOT NULL,
    contact_information  TEXT        NOT NULL,
    birthday             DATE        NOT NULL,
    specialization       TEXT        NOT NULL,
    years_of_experience  INTEGER     NOT NULL CHECK (years_of_experience >= 0)
);

CREATE TABLE patient (
    id                   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name                 TEXT        NOT NULL,
    contact_information  TEXT        NOT NULL,
    birthday             DATE        NOT NULL,
    medical_history      TEXT
);

CREATE TABLE treatment (
    id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type    TEXT            NOT NULL,
    name    TEXT            NOT NULL,
    cost    NUMERIC(12,2)   NOT NULL CHECK (cost >= 0)
);

CREATE TABLE time_treatment (
    id        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type      TEXT            NOT NULL,
    name      TEXT            NOT NULL,
    cost      NUMERIC(12,2)   NOT NULL CHECK (cost >= 0),
    duration  INTERVAL        NOT NULL
);

CREATE TABLE room (
    id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type          TEXT        NOT NULL,
    number        TEXT        NOT NULL,
    availability  BOOLEAN     NOT NULL DEFAULT TRUE
);

CREATE TABLE appointment (
    appointment_date  DATE    NOT NULL,
    appointment_time  TIME    NOT NULL,
    reason            TEXT,
    patient_id        INTEGER NOT NULL,
    doctor_id         INTEGER NOT NULL,
    CONSTRAINT pk_appointment PRIMARY KEY (appointment_date, appointment_time),
    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (patient_id) REFERENCES patient(id),
    CONSTRAINT fk_appointment_doctor
        FOREIGN KEY (doctor_id)  REFERENCES doctor(id)
);

CREATE TABLE stay (
    id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    start_date  TIMESTAMP   NOT NULL,
    end_date    TIMESTAMP   NOT NULL,
    patient_id  INTEGER     NOT NULL,
    CONSTRAINT fk_stay_patient
        FOREIGN KEY (patient_id) REFERENCES patient(id),
    CONSTRAINT chk_stay_interval CHECK (end_date > start_date)
);

CREATE TABLE bill (
    id             INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date_issued    DATE          NOT NULL,
    total_costs    NUMERIC(12,2) NOT NULL CHECK (total_costs >= 0),
    payment_status TEXT          NOT NULL,
    patient_id     INTEGER       NOT NULL,
    CONSTRAINT fk_bill_patient
        FOREIGN KEY (patient_id) REFERENCES patient(id)
);

CREATE TABLE is_assigned (
    room_id  INTEGER NOT NULL,
    stay_id  INTEGER NOT NULL,
    CONSTRAINT pk_is_assigned PRIMARY KEY (room_id, stay_id),
    CONSTRAINT fk_is_assigned_room
        FOREIGN KEY (room_id) REFERENCES room(id),
    CONSTRAINT fk_is_assigned_stay
        FOREIGN KEY (stay_id) REFERENCES stay(id)
);

CREATE TABLE is_prescribed (
    treatment_id      INTEGER NOT NULL,
    appointment_date  DATE    NOT NULL,
    appointment_time  TIME    NOT NULL,
    CONSTRAINT pk_is_prescribed PRIMARY KEY (treatment_id, appointment_date, appointment_time),
    CONSTRAINT fk_is_prescribed_treatment
        FOREIGN KEY (treatment_id) REFERENCES treatment(id),
    CONSTRAINT fk_is_prescribed_appointment
        FOREIGN KEY (appointment_date, appointment_time)
        REFERENCES appointment(appointment_date, appointment_time)
);

CREATE INDEX idx_appointment_patient ON appointment(patient_id);
CREATE INDEX idx_appointment_doctor  ON appointment(doctor_id);
CREATE INDEX idx_stay_patient        ON stay(patient_id);
CREATE INDEX idx_bill_patient        ON bill(patient_id);

COMMIT;
