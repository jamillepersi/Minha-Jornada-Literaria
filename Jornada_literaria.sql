-- 📚 PROJETO: Minha Jornada Literária
-- 📝 Arquivo: consultas_minha_jornada.sql
-- 📌 Descrição: Consultas SQL para análise da base de livros

USE minha_jornada;

-- =====================================================
-- 1) Quantidade de livros lidos por ano
-- =====================================================
SELECT 
    YEAR(`Inicio da leitura`) AS Ano,
    COUNT(*) AS Livros_Lidos
FROM livros
GROUP BY YEAR(`Inicio da leitura`)
ORDER BY Ano;

-- =====================================================
-- 2) Quantidade de livros por gênero
-- =====================================================
SELECT 
    Gênero,
    COUNT(*) AS Livros_Lidos
FROM livros
GROUP BY Gênero
ORDER BY Livros_Lidos DESC;

-- =====================================================
-- 3) Top 10 autores mais lidos
-- =====================================================
SELECT 
    Autor,
    COUNT(*) AS Livros_Lidos
FROM livros
GROUP BY Autor
ORDER BY Livros_Lidos DESC
LIMIT 10;

-- =====================================================
-- 4) Total de páginas lidas
-- =====================================================
SELECT SUM(`Nº de páginas`) AS Total_Paginas
FROM livros;

-- =====================================================
-- 5) Páginas lidas por ano
-- =====================================================
SELECT 
    YEAR(`Inicio da leitura`) AS Ano,
    SUM(`Nº de páginas`) AS Total_Paginas
FROM livros
GROUP BY YEAR(`Inicio da leitura`)
ORDER BY Ano;

-- =====================================================
-- 6) Média de notas por gênero
-- =====================================================
SELECT 
    Gênero,
    ROUND(AVG(Nota), 2) AS Media_Nota
FROM livros
GROUP BY Gênero
ORDER BY Media_Nota DESC;

-- =====================================================
-- 7) Ritmo médio de leitura (páginas por dia)
-- =====================================================
SELECT ROUND(AVG(`Pace(Páginas/Dias`), 2) AS Media_Paginas_Por_Dia
FROM livros;

-- =====================================================
-- 8) Eficiência de leitura (páginas por dia) por livro
-- =====================================================
SELECT 
    Título, 
    ROUND(`Nº de páginas` / `Dias de leitura`, 2) AS Paginas_Por_Dia
FROM livros
ORDER BY Paginas_Por_Dia DESC;

-- =====================================================
-- 9) Tempo médio de leitura por livro
-- =====================================================
SELECT 
    ROUND(AVG(`Dias de leitura`), 2) AS Media_Dias
FROM livros;

-- =====================================================
-- 10) Média de tempo de leitura por gênero
-- =====================================================
SELECT 
    Gênero, 
    ROUND(AVG(`Dias de leitura`), 2) AS Media_Dias
FROM livros
GROUP BY Gênero
ORDER BY Media_Dias;

-- =====================================================
-- 11) Média de páginas por livro em cada ano
-- =====================================================
SELECT 
    YEAR(`Inicio da leitura`) AS Ano, 
    ROUND(AVG(`Nº de páginas`), 2) AS Media_Paginas
FROM livros
GROUP BY YEAR(`Inicio da leitura`)
ORDER BY Ano;

-- =====================================================
-- 12) Livro mais longo e mais curto
-- =====================================================
-- Livro mais longo
SELECT 
    Título, Autor, `Nº de páginas`
FROM livros
ORDER BY `Nº de páginas` DESC
LIMIT 1;

-- Livro mais curto
SELECT 
    Título, Autor, `Nº de páginas`
FROM livros
ORDER BY `Nº de páginas` ASC
LIMIT 1;

-- =====================================================
-- 13) Livro com maior nota por gênero (apenas 1 por gênero)
-- =====================================================
WITH ranked_max AS (
    SELECT 
        Gênero,
        Título,
        Nota,
        ROW_NUMBER() OVER (PARTITION BY Gênero ORDER BY Nota DESC, Título ASC) AS rn
    FROM livros
)
SELECT 
    Gênero, Título, Nota
FROM ranked_max
WHERE rn = 1;

-- =====================================================
-- 14) Livro com menor nota por gênero (apenas 1 por gênero)
-- =====================================================
WITH ranked_min AS (
    SELECT 
        Gênero,
        Título,
        Nota,
        ROW_NUMBER() OVER (PARTITION BY Gênero ORDER BY Nota ASC, Título ASC) AS rn
    FROM livros
)
SELECT 
    Gênero, Título, Nota
FROM ranked_min
WHERE rn = 1;
