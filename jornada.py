import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

# Criar pasta "graficos" se não existir
os.makedirs("graficos", exist_ok=True)

# Lendo a base
df = pd.read_csv("Pasta1.csv", sep=';', encoding='latin1')

# Padronizar nomes das colunas
df.columns = (
    df.columns.str.strip()
              .str.lower()
              .str.replace(' ', '_')
              .str.replace('º', 'o')
              .str.replace('é', 'e')
)

print(df.columns)

# Converter datas
df['inicio_da_leitura'] = pd.to_datetime(df['inicio_da_leitura'], dayfirst=True, errors='coerce')
df['fim_da_leitura'] = pd.to_datetime(df['fim_da_leitura'], dayfirst=True, errors='coerce')

# Calcular duração
df['dias_de_leitura'] = (df['fim_da_leitura'] - df['inicio_da_leitura']).dt.days

# Estatísticas básicas
print("\n📚 Estatísticas gerais:")
print("Total de livros lidos:", len(df))
print("Total de páginas lidas:", df['no_de_páginas'].sum())
print("Média de páginas por livro:", round(df['no_de_páginas'].mean(), 2))
print("Média de nota:", round(df['nota'].mean(), 2))
print("Média de dias por leitura:", round(df['dias_de_leitura'].mean(), 2))

# -----------------------------
# Gráfico 1 — Distribuição das notas
plt.figure(figsize=(6,4))
sns.countplot(x='nota', data=df, hue='nota', palette='viridis', legend=False)
plt.title('Distribuição das Notas')
plt.savefig("graficos/distribuicao_notas.png", dpi=300, bbox_inches='tight')
plt.show()

# Gráfico 2 — Tempo médio de leitura por ano
media_tempo = df.groupby('ano')['dias_de_leitura'].mean()
media_tempo.plot(kind='bar', figsize=(6,4), title='Tempo médio de leitura por ano')
plt.ylabel('Dias')
plt.savefig("graficos/tempo_medio_por_ano.png", dpi=300, bbox_inches='tight')
plt.show()

# Gráfico 3 — Autores mais lidos
autores = df['autor'].value_counts().head(10)
autores.plot(kind='barh', figsize=(6,4), title='Top 10 Autores Mais Lidos')
plt.savefig("graficos/autores_mais_lidos.png", dpi=300, bbox_inches='tight')
plt.show()

# Gráfico 4 — Nota média por gênero (atualizado para não gerar warnings)
plt.figure(figsize=(8,5))
sns.barplot(
    data=df,
    x='gênero',
    y='nota',
    estimator='mean',
    errorbar=None,   # substitui ci=None
    palette='magma'
)
plt.title('Nota média por gênero')
plt.xlabel('Gênero')
plt.ylabel('Nota média')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("graficos/nota_media_por_genero.png", dpi=300, bbox_inches='tight')
plt.show()

# Gráfico 5 — Relação entre nº de páginas e nota
plt.figure(figsize=(8,5))
sns.scatterplot(data=df, x='no_de_páginas', y='nota', hue='gênero', palette='viridis', alpha=0.8)
plt.title('Relação entre número de páginas e nota')
plt.xlabel('Número de páginas')
plt.ylabel('Nota')
plt.tight_layout()
plt.savefig("graficos/relacao_paginas_nota.png", dpi=300, bbox_inches='tight')
plt.show()

# -----------------------------
# Meses com mais leituras
meses = df['mês'].value_counts().head(3)
print("Meses com mais leituras:\n", meses)

# Relação entre tamanho do livro e nota
correlacao = df[['no_de_páginas', 'nota']].corr()
print("\nCorrelação entre número de páginas e nota:")
print(correlacao)