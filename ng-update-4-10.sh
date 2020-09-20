#!/bin/bash

COLOR_RED="31"
COLOR_GREEN="32"
COLOR_BLUE="34"

print_info() {
  echo -e "\n[\e[${COLOR_BLUE}mINFO\e[0m] $1\n"
}

print_success() {
  echo -e "\n[\e[${COLOR_GREEN}mSUCCESS\e[0m] $1\n"
}

print_error() {
  echo -e "\n[\e[${COLOR_RED}mERROR\e[0m] $1\n"
}

if [ -z "$1" ]; then
  print_error "Necessário informar a aula"
  exit
fi

AULA="$1"
COMMIT_MESSAGE="Atualiza aula ${AULA} para o ng10"

commit_ammend() {
  git add .
  git commit --amend -m "${COMMIT_MESSAGE}"
}

print_info "Instalando o @angular/cli@6"
npm install @angular/cli@6 --save-dev

git add .
git commit -m "${COMMIT_MESSAGE}"

print_info "Instalando o @angular/core@6 e atualizando o codelyzer"
ng update @angular/core@6 codelyzer
commit_ammend

print_info "Removendo o rxjs 5"
# npx rxjs-tslint
rxjs-5-to-6-migrate -p src/tsconfig.app.json
# npm rm rxjs-compat
commit_ammend

print_info "Migrando a configuração do @angular/cli@1.7.4 para o @angular/cli@6"
ng update @angular/cli --migrate-only --from=1.7.4
commit_ammend

print_info "Instalando o Angular 7"
ng update @angular/cli@7 @angular/core@7
commit_ammend

print_info "Instalando o Angular 8"
ng update @angular/cli@8 @angular/core@8
commit_ammend

print_info "Instalando o Angular 9"
ng update @angular/core@9 @angular/cli@9
commit_ammend

print_info "Instalando o Angular 10"
ng update @angular/core @angular/cli
commit_ammend

print_info "Migrando a configuração do @angular/cli 9 para o 10"
ng update @angular/cli --migrate-only --from 9 --to 10
commit_ammend

print_info "Migrando a configuração do @angular/core 9 para o 10"
ng update @angular/core --migrate-only --from 9 --to 10
commit_ammend

# ng update
# npm outdated

print_info "Atualizando demais dependências"
ng update bootstrap
commit_ammend
