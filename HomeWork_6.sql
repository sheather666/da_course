-- Таблица студентов
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    username VARCHAR(50) unique,
    bio TEXT,
    mobile VARCHAR(15),
    has_picture BOOLEAN
);

-- Заливаем данные в таблицу students
INSERT INTO students (student_id, student_name, username, bio, mobile, has_picture)
VALUES 
    (1, 'Азиз Абдуллаев', 'username1', 'Краткая информация', '902000734', TRUE)
    ,(2, 'Муртазоев Аличон', 'username2', 'Краткая информация', '0987654321', true)
    ,(3, 'Дарк Бехзод', 'username3', 'Краткая информация', '0987654321', TRUE)
    ,(4, 'Ибодуло', 'username4', 'Краткая информация', '0987634382', FALSE)
    ,(5, 'Хаким', 'username5', 'Краткая информация', '0987653412', FALSE)
    ,(6, 'Садриддин Хочазода', 'username6', 'Краткая информация', '0978953321', FALSE)
    ,(7, 'Алишер Нарзуллоев', 'username7', 'Краткая информация', '0897564521', TRUE)
    ,(8, 'Фарход ЖКХ', 'username8', 'Краткая информация', '0987654236', TRUE)
    ,(9, 'Мунира К', 'username9', 'Краткая информация', '0953613321', FALSE)
    ,(10, 'Александр Лешукович', 'username10', 'Краткая информация', '0987664355', TRUE)
    ,(11, 'Джамшед Б.', 'username11', 'Краткая информация', '0987654353', FALSE)
    ,(12, 'Фарход Исмаилов', 'username12', 'Краткая информация', '0987654421', TRUE);


-- Индекс на поле username
CREATE INDEX idx_username ON students (username);

-- Таблица уроков
CREATE TABLE lessons (
    lesson_id INT PRIMARY KEY,
    lesson_name VARCHAR(100),
    lesson_date DATE,
    attendance BOOLEAN
);
-- Заливаем данные в таблицу lessons
INSERT INTO lessons (lesson_id, lesson_name, lesson_date, attendance)
VALUES 
    (1, 'SQL intro', '2024-10-18', TRUE)
    ,(2, 'SQL select_filter_aggregate', '2024-10-18', TRUE)
    ,(3, 'SQL Strings_and_Dates', '2024-10-21', TRUE)
    ,(4, 'SQL create_and_edit_tables', '2024-09-23', TRUE);

-- Таблица оценок
CREATE TABLE scores (
    score_id INT PRIMARY KEY,
    student_id INT,
    lesson_id INT,
    score DECIMAL(5, 2),
    FOREIGN KEY (student_id) REFERENCES students (student_id),
    FOREIGN KEY (lesson_id) REFERENCES lessons (lesson_id)
);

-- Заливаем данные в таблицу Scores
INSERT INTO scores (score_id, student_id, lesson_id, score)
VALUES 
    (1, 1, 1, NULL),
    (2, 1, 2, NULL),
    (3, 1, 3, NULL),
    (4, 1, 4, NULL);
   
-- Создаем представление my_result
CREATE VIEW my_results AS
SELECT 
    s.student_id,
    s.student_name,
    s.username,
    s.mobile,
    COUNT(l.lesson_id) AS lessons_attended,
    AVG(sc.score) AS avg_score
FROM 
    students s
LEFT JOIN 
    scores sc ON s.student_id = sc.student_id
LEFT JOIN 
    lessons l ON sc.lesson_id = l.lesson_id AND l.attendance = TRUE
GROUP BY 
    s.student_id, s.student_name, s.username, s.mobile;
   
   
   
   select * from my_results;

