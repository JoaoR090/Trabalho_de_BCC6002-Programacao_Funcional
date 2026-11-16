-- 0 é morto, 1 é vivo
criarMatriz y x = replicate y (replicate x 0)

pegarVizinhos matriz y x =
    let
        limite_linha = length matriz - 1
        limite_col = length (head matriz) - 1

        coordenadas = [ (y-1, x), -- cima
                        (y+1,x), -- baixo
                        (y-1, x-1), -- esquerda cima
                        (y+1, x-1), -- esquerda baixo
                        (y-1, x+1), -- direita cima
                        (y+1, x+1), -- direita baixo
                        (y,x-1), -- esquerda
                        (y,x+1)] -- direita

        coordenadasValidas = filter (\(linha, col) -> linha >= 0 && linha <= limite_linha && col >= 0 && col <= limite_col) coordenadas
    
    in 
        map(\(linha, col) -> (matriz !! linha) !! col) coordenadasValidas

mortePorIsolamento matriz y x =
    let
        vizinhos = pegarVizinhos matriz y x

        quantidadeVizinhosVivos = length (filter (\x -> x > 0) vizinhos)
    in 
        quantidadeVizinhosVivos < 2 -- returna true se morreu

mortePorSuperpopulacao matriz y x =
    let
        vizinhos = pegarVizinhos matriz y x
        quantidadeVizinhosVivos = length (filter (\x -> x > 0) vizinhos)
    in
        quantidadeVizinhosVivos > 3 -- retorna true se morreu

reproducao matriz y x =
    let
        vizinhos = pegarVizinhos matriz y x
        quantidadeVizinhosVivos = length (filter (\x -> x > 0) vizinhos)
    in
        quantidadeVizinhosVivos == 3 -- retorna true se é possivel a reprodução

proximoEstado estadoAtual matriz y x
    | estadoAtual == 1 = if not (mortePorIsolamento matriz y x) && not (mortePorSuperpopulacao matriz y x) then 1 else 0
    | estadoAtual == 0 = if reproducao matriz y x then 1 else 0
    | otherwise = estadoAtual

proximaGeracao matriz =
    let
        limite_linha = length matriz - 1
        limite_col = length (head matriz) - 1

        novaMatriz = map(\y -> map(\x -> 
            let
                valor = (matriz !! y) !! x
            in
                proximoEstado valor matriz y x
            ) [0 .. limite_col]) [0 .. limite_linha]
    in
        novaMatriz