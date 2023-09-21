ALTER TABLE addresses
    ADD CONSTRAINT pk_address_id PRIMARY KEY(id),

    ADD CONSTRAINT valid_house CHECK(house > 0),

    ALTER COLUMN town SET NOT NULL,
    ALTER COLUMN street SET NOT NULL,
    ALTER COLUMN house SET NOT NULL;

ALTER TABLE schools
    ADD CONSTRAINT pk_school_id PRIMARY KEY(id),
    ADD CONSTRAINT fk_address_id FOREIGN KEY(id_address) REFERENCES addresses(id),

    ALTER COLUMN construct_year SET NOT NULL,
    ALTER COLUMN id_address SET NOT NULL;

ALTER TABLE classes
    ADD CONSTRAINT pk_class_id PRIMARY KEY(id),
    ADD CONSTRAINT fk_school_id FOREIGN KEY(id_school) REFERENCES schools(id),
    
    ADD CONSTRAINT valid_grade CHECK(grade > 0 and grade < 12),

    ALTER COLUMN grade SET NOT NULL,
    ALTER COLUMN letter SET NOT NULL;

ALTER TABLE students
    ADD CONSTRAINT pk_puple_id PRIMARY KEY(id),
    ADD CONSTRAINT fk_class_id FOREIGN KEY(id_class) REFERENCES classes(id),

    ADD CONSTRAINT valid_gender CHECK(gender = 'М' or gender = 'Ж'),

    ALTER COLUMN full_name SET NOT NULL,
    ALTER COLUMN phone SET NOT NULL;

ALTER TABLE teachers
    ADD CONSTRAINT pk_teacher_id PRIMARY KEY(id),
    
    ADD CONSTRAINT valid_age CHECK(age > 24 and age < 66),
    ADD CONSTRAINT valid_gender CHECK(gender = 'М' or gender = 'Ж'),

    ALTER COLUMN full_name SET NOT NULL,
    ALTER COLUMN age SET NOT NULL;

ALTER TABLE lessons
    ADD CONSTRAINT fk_teacher_id FOREIGN KEY(id_teacher) REFERENCES teachers(id),
    ADD CONSTRAINT fk_class_id FOREIGN KEY(id_class) REFERENCES classes(id),

    ALTER COLUMN title SET NOT NULL;