#!/usr/bin/env bash
# Reorganiza o repositório LAB_AOC-II preservando o histórico do Git (usa git mv).
# Uso: dentro da pasta do repo clonado ->  bash reorganizar.sh
set -euo pipefail

[ -d .git ] || { echo "Rode dentro da pasta do repositório LAB_AOC-II."; exit 1; }

mv_() { mkdir -p "$(dirname "$2")"; git mv "$1" "$2"; }

# 01 a 04 e 06: fundamentos, strings e arquivos (numeração em ordem de data)
mv_ "20250213-Aula_01/aula 01.asm"                                   "labs/01-aula-01/aula01.asm"
mv_ "20250213-Aula_01/mips1.asm"                                     "labs/01-aula-01/soma-dois-numeros.asm"
mv_ "20250220-Comandos_Basicos/equacao.asm_addK"                     "labs/02-comandos-basicos/equacao.asm"
mv_ "20250220-Comandos_Basicos/Prox_Tarefa.txt"                      "labs/02-comandos-basicos/proxima-tarefa.txt"
mv_ "20250227-BuscaCaracter_String/procura_caracter_esqueleto-1.asm" "labs/03-busca-caractere/esqueleto.asm"
mv_ "20250227-BuscaCaracter_String/procura_caracter_digitado-2.asm"  "labs/03-busca-caractere/procura-caractere.asm"
mv_ "20250306-LeituraDeArquivos/arquivo_le (1).asm"                  "labs/04-leitura-arquivos/leitura-arquivo.asm"
mv_ "20250327-Escrita_Copiada/WriteCopy.asm"                         "labs/06-escrita-copiada/escrita-copiada.asm"
mv_ "arquivo.txt"                                                    "labs/06-escrita-copiada/arquivo.txt"
mv_ "arquivo2.txt"                                                   "labs/06-escrita-copiada/arquivo2.txt"

# 05 e 07 a 13: avaliações e laboratórios seguintes
mv_ "20250320-Atividade_Avaliativa/Tarefa01Lab.asm"                  "labs/05-av01-troca-caractere/troca-caractere.asm"
mv_ "20250403-Mem_Copy/memcopy.asm"                                  "labs/07-memcopy/memcopy.asm"
mv_ "20250410-Atividade_Avaliativa02/End_IP-Corrijido"               "labs/08-av02-classes-ip/classe-ip.asm"
mv_ "20250424-Print_Binario/Print_Bin.asm"                           "labs/09-print-binario/print-binario.asm"
mv_ "20250515-Conta-Com-Float/Op01-comFloat.asm"                     "labs/10-ponto-flutuante/operacoes-float.asm"
mv_ "20250515-Conta-Com-Float/Op02-ImprimeConv-NaoConv.asm"          "labs/10-ponto-flutuante/float-como-inteiro.asm"
mv_ "20250522-Atividade_Avaliativa03/Atividade_Avaliativa03.asm"     "labs/11-av03-distancia-hamming/hamming.asm"
mv_ "20250529-Exceptions/Exceptions.asm"                             "labs/12-excecoes/excecoes.asm"
mv_ "20250529-Exceptions/mips1.asm"                                  "labs/12-excecoes/trap-simples.asm"
mv_ "20250605-Atividade_Avaliativa04/Trabalho04.asm"                 "labs/13-av04-potencia-float/trabalho04.asm"

# Material de apoio
mv_ "Guia-MIPS.pdf"     "material-de-apoio/Guia-MIPS.pdf"
mv_ "Resumo-MIPS.docx"  "material-de-apoio/Resumo-MIPS.docx"

# Rascunhos (versões anteriores do Hamming). Apague a pasta se não quiser manter.
mv_ "teste-Atv03.asm"   "rascunhos/hamming-rascunho-a.asm"
mv_ "Corpo"             "rascunhos/hamming-rascunho-b.asm"

# Duplicatas exatas (mesmo conteúdo de arquivos que já estão acima)
git rm -q "Atividade_Avaliativa03.asm"   # idêntico a labs/11-av03-distancia-hamming/hamming.asm
git rm -q "teste"                        # idêntico a rascunhos/hamming-rascunho-b.asm
git rm -q "Atv04-ChatGPT/Teste.asm"      # idêntico a labs/13-av04-potencia-float/trabalho04.asm

echo "Pronto. Confira com 'git status' e faça o commit:"
echo "  git commit -m 'Reorganiza laboratorios em labs/ e remove duplicatas'"
