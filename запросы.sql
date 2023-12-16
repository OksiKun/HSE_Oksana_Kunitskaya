-- 1) Вывод списка студентов по определённому предмету
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