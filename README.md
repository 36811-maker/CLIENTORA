# CLIENTORA — CRM

Sistema web de CRM desenvolvido com **HTML5, CSS3 e JavaScript puro**, com modo demonstração local e estrutura preparada para integração com Supabase.

## Como executar

1. Extraia a pasta `CLIENTORA`.
2. Abra a pasta no VS Code.
3. Para evitar limitações do navegador com arquivos locais, execute com uma extensão de servidor local (por exemplo, Live Server).
4. Abra `login.html`.
5. Clique em **Entrar no modo demonstração**.

Os registros da demonstração ficam no `localStorage` do navegador. Eles não são compartilhados entre dispositivos ou usuários.

## Configurar Supabase

1. Crie um projeto no Supabase.
2. Abra `Project Settings > API`.
3. Copie Project URL e anon/public key.
4. Preencha `js/config.js`.
5. Execute `database/schema.sql` no SQL Editor do Supabase.
6. Configure usuários em Authentication.

**Importante:** esta entrega fornece uma base funcional de interface e CRUD local. O login Supabase está conectado no formulário, mas os módulos de dados ainda usam o modo local. Para produção multiusuário, implemente as operações de leitura/escrita dos módulos usando Supabase e valide as políticas RLS. Nunca exponha `service_role` no frontend.

## Módulos incluídos

Dashboard, clientes, leads, oportunidades, pipeline Kanban com arrastar e soltar, negociações, atividades, agenda, tarefas, equipes, usuários, relatórios CSV, campanhas, notificações, perfil e configurações.

## Estrutura

- `*.html`: páginas do sistema.
- `css/`: identidade visual, componentes, autenticação e responsividade.
- `js/`: configuração, dados locais, autenticação e aplicação.
- `database/schema.sql`: estrutura inicial do banco.
