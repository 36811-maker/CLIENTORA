# Publicação

## GitHub Pages
O projeto é estático e pode ser publicado no GitHub Pages para demonstração. Configure o repositório e selecione a branch/pasta em Settings > Pages.

## Render
Crie um Static Site apontando para a pasta raiz do projeto. Não há etapa de build. Para rotas e páginas estáticas, mantenha os arquivos HTML na raiz.

## Antes de uso real
- Configure Supabase URL e anon key.
- Implemente a camada de dados Supabase para cada módulo (esta versão usa localStorage para CRUD).
- Complete as políticas RLS para vendedor/gerente/administrador.
- Configure domínio, recuperação de senha e usuários.
