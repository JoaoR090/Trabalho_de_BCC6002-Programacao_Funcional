# Analisador Textual Haskell

### Sobre

Um analisador de textos feito em *Haskell* com suporte a frequência absoluta e relativa de palavras (com ordenação e filtragem por pontuação e *stop words*). O projeto usa conceitos de linguagem funcional dentre eles:
 - Recursão.
 - *Lambdas*.
 - Composição de funções.
 - Imutabilidade.

### Exemplos de uso

### Como executar

#### Pré-requisitos

- [GHCup](https://www.haskell.org/ghcup/) instalado, com o GHC e o Cabal disponíveis no terminal.
- A partir da pasta `analisador`, verifique a instalação com:

```bash
ghc --version
cabal --version
```

#### Passo a passo

1. Abra um terminal na pasta do projeto:

   ```bash
   cd analisador
   ```

2. Compile o executável:

   ```bash
   cabal build
   ```

3. Execute o programa. Argumentos devem vir depois de `--`:

   ```bash
   cabal run analisador -- exemplo.txt
   ```

   Também é possível passar texto diretamente:

   ```bash
   cabal run analisador -- "um texto de exemplo"
   ```