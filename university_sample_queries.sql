-- Query 1
SELECT * FROM students;

-- Query 2
SELECT first_name, last_name, email FROM students;

-- Query 3
SELECT * FROM courses WHERE department = 'Statistics';

-- Query 4
SELECT * FROM students ORDER BY enrollment_year DESC;

-- Query 5
SELECT s.first_name, s.last_name, c.course_name, e.grade
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id;

-- Query 6
SELECT department, COUNT(*) AS course_count
    FROM courses
    GROUP BY department;

-- Query 7
SELECT c.course_name, AVG(
        CASE 
            WHEN e.grade IN ('A', 'A-') THEN 4.0
            WHEN e.grade = 'B+' THEN 3.3
            WHEN e.grade = 'B' THEN 3.0
            WHEN e.grade = 'C+' THEN 2.3
            ELSE 0.0
        END
    ) AS average_gpa
    FROM courses c
    JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_name
    HAVING COUNT(e.grade) > 2;

-- Query 8
SELECT first_name, last_name
    FROM students
    WHERE student_id IN (
        SELECT student_id
        FROM enrollments
        WHERE course_id = (
            SELECT course_id FROM courses WHERE course_name = 'Machine Learning'
        )
    );

-- Query 9
SELECT s.first_name, s.last_name, e.grade,
           RANK() OVER (PARTITION BY e.course_id ORDER BY 
               CASE 
                   WHEN e.grade = 'A' THEN 4.0
                   WHEN e.grade = 'A-' THEN 3.7
                   WHEN e.grade = 'B+' THEN 3.3
                   WHEN e.grade = 'B' THEN 3.0
                   WHEN e.grade = 'C+' THEN 2.3
                   ELSE 0.0
               END DESC) AS rank_in_course
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id;

-- Query 10
WITH top_courses AS (
        SELECT course_id, COUNT(*) AS student_count
        FROM enrollments
        GROUP BY course_id
        ORDER BY student_count DESC
        LIMIT 3
    )
    SELECT c.course_name, tc.student_count
    FROM top_courses tc
    JOIN courses c ON tc.course_id = c.course_id;

