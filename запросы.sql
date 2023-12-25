-- 1) выводить список студентов по определённому предмету
SELECT
    users.*
FROM
    study
    INNER JOIN subjects ON study.subject_id = subjects.id
    INNER JOIN students ON study.group_id = students.group
    INNER JOIN users ON students.user = users.id
WHERE
    subjects.id = 1;


-- 2) выводить список предметов, которые преподаёт конкретный преподаватель
SELECT
    subjects.*
FROM
    study
    INNER JOIN subjects ON study.subject_id = subjects.id
WHERE
    study.teacher_id = 1;


-- 3) выводить средний балл студента по всем предметам
SELECT
    users.fio,
    AVG(marks.mark) as rating
FROM
    marks
    INNER JOIN users ON marks.student = users.id
GROUP BY
    marks.student;


-- 4) выводить рейтинг преподавателей по средней оценке студентов
SELECT
    users.fio,
    AVG(marks.mark) as rating
FROM
    marks
    INNER JOIN study ON marks.study = study.id
    INNER JOIN users ON study.teacher_id = users.id
GROUP BY
    study.teacher_id
ORDER BY
    rating DESC;


-- 5) выводить список преподавателей, которые преподавали более 3 предметов за последний год
SELECT
    fio
FROM
    study
    INNER JOIN users ON study.teacher_id = users.id
WHERE
    study.year = YEAR(NOW())
GROUP BY
    study.teacher_id
HAVING
    COUNT(study.id) > 3;


-- 6) выводить список студентов, которые имеют средний балл выше 4 по математическим предметам, но ниже 3 по гуманитарным
WITH average_marks as
(
    SELECT
        marks.student,
        subjects.type,
        AVG(marks.mark) as average
    FROM
        marks
        INNER JOIN study ON marks.study = study.id
        INNER JOIN subjects ON study.subject_id = subjects.id
    GROUP BY
        marks.student,
        subjects.type
    HAVING
        AVG(marks.mark)
)

SELECT
    users.*
FROM
    average_marks as math_marks
    INNER JOIN average_marks as hum_marks ON hum_marks.student = math_marks.student
    INNER JOIN users ON math_marks.student = users.id
WHERE
    math_marks.type = 'математический'
    AND hum_marks.type = 'гуманитарный'
    AND math_marks.average > 4 AND hum_marks.average < 3;


-- 7) определить предметы, по которым больше всего двоек в текущем семестре
WITH bad_mark_subjects as
(
    SELECT
        study.subject_id,
        COUNT(*) as count
    FROM
        study
        INNER JOIN marks ON study.id = marks.study
    WHERE
        study.year = YEAR(CURRENT_DATE())
        AND study.semester = CASE WHEN MONTH(CURRENT_DATE()) <= 6 THEN 1 ELSE 2 END
        AND marks.mark = 2
    GROUP BY
        study.subject_id
)

SELECT
    subjects.*
FROM
    bad_mark_subjects
    INNER JOIN subjects ON bad_mark_subjects.subject_id = subjects.id
WHERE
    bad_mark_subjects.count = (SELECT MAX(count) FROM bad_mark_subjects);


-- 8) выводить студентов, которые получили высший балл по всем своим экзаменам, и преподавателей, которые вели эти предметы
SELECT
    students.fio as student,
    subjects.name as subject,
    teachers.fio as teacher
FROM
    marks
    INNER JOIN study ON marks.study = study.id
    INNER JOIN subjects ON study.subject_id = subjects.id
    INNER JOIN users as students ON marks.student = students.id
    INNER JOIN users as teachers ON study.teacher_id = teachers.id
WHERE
    marks.student IN (SELECT marks.student FROM marks GROUP BY marks.student HAVING MIN(marks.mark) = 5)
GROUP BY
    marks.student,
    marks.study,
    study.teacher_id;


-- 9) просматривать изменение среднего балла студента по годам обучения
WITH average_marks as
(
    SELECT
        marks.student,
        study.year,
        AVG(marks.mark) as average
    FROM
        marks
        INNER JOIN study on marks.study = study.id
    GROUP BY
        marks.student,
        study.year
)

SELECT
    users.fio,
    average_marks.year,
    average_marks.average,
    average_marks.average - IFNULL(LAG(average_marks.average, 1) OVER (ORDER BY average_marks.year), 0) as delta
FROM
    average_marks
    INNER JOIN users ON average_marks.student = users.id
WHERE
    average_marks.student = 1;


-- 10) определить группы, в которых средний балл выше, чем в других, по аналогичным предметам
WITH average_marks as
(
    SELECT
        students.group,
        study.subject_id,
        AVG(marks.mark) as average
    FROM
        marks
        INNER JOIN students ON marks.student = students.user
        INNER JOIN study ON marks.study = study.id
    GROUP BY
        students.group,
        study.subject_id
),
max_marks as
(
    SELECT
        average_marks.subject_id,
        MAX(average_marks.average) as max_mark
    FROM
        average_marks
    GROUP BY
        average_marks.subject_id
),
max_marks_count as
(
    SELECT
        max_marks.subject_id,
        max_marks.max_mark,
        COUNT(average_marks.average) as count
    FROM
        max_marks
        INNER JOIN average_marks
            ON average_marks.average = max_marks.max_mark AND average_marks.subject_id = max_marks.subject_id
    GROUP BY
        max_marks.subject_id,
        max_marks.max_mark
)

SELECT
    groups.*
FROM
    max_marks_count
    INNER JOIN average_marks ON average_marks.average = max_marks_count.max_mark AND average_marks.subject_id = max_marks_count.subject_id
    INNER JOIN subjects ON max_marks_count.subject_id = subjects.id
    INNER JOIN `groups` ON average_marks.group = `groups`.id
WHERE
    max_marks_count.count = 1;

-- 11) Вставьте записи о новом студенте с его личной информацией: ФИО, дата рождения, контактные данные и др
INSERT INTO users (fio, birth_date, email, phone, sex) VALUES ('Иванов Иван Иванович', '2000-01-01', 'ivan@ivanov.ru', '79991234567', 'м');

-- 12) обновление контактной информации преподавателя, например, электронной почты или номера телефона, на основе его идентификационного номера или ФИО
UPDATE users SET email = 'new@email.com', phone = '79001000000' WHERE id = 1;

-- 13) удаление записи о предмете, который больше не преподают в учебном заведении
DELETE FROM subjects WHERE id = 9;

-- 14) вставка новой записи об оценке, выставленной студенту по определённому предмету, с указанием даты, преподавателя и полученной оценки
INSERT INTO marks (study, student, mark, date) VALUES (1, 1, 4, '2023-12-25');