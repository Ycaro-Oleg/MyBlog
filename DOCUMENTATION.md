# Documentação do Blog Pessoal com Ruby on Rails 8

Bem-vindo à documentação do Blog Pessoal, um projeto desenvolvido com Ruby on Rails 8, focado em uma experiência de autoria moderna, uma interface limpa e agradável, e utilizando as mais recentes funcionalidades do framework.

## 1. Introdução

Este blog foi criado para permitir que o autor gerencie seus próprios posts de forma eficiente, com um editor de texto rico em Markdown e uma interface de usuário (UI) minimalista e intuitiva. Além disso, oferece um sistema de autenticação para que outros usuários possam comentar nos posts, e a flexibilidade de alternar entre os modos claro e escuro.

## 2. Arquitetura

O projeto segue a arquitetura Model-View-Controller (MVC) padrão do Ruby on Rails. As principais tecnologias e conceitos utilizados incluem:

*   **Ruby on Rails 8:** O framework principal para o desenvolvimento web.
*   **PostgreSQL:** Banco de dados relacional robusto e escalável.
*   **Hotwire (Turbo e Stimulus):** Para uma experiência de usuário rápida e dinâmica, com atualizações de página parciais e interatividade JavaScript mínima.
    *   **Turbo:** Acelera a navegação e as atualizações de formulário, proporcionando uma experiência de SPA (Single Page Application) sem a complexidade do JavaScript.
    *   **Stimulus:** Um framework JavaScript modesto que adiciona comportamento ao HTML existente, ideal para interações de UI como a troca de tema.
*   **Tailwind CSS:** Um framework CSS utilitário que permite construir designs personalizados rapidamente, com foco em classes de utilidade para estilização.
*   **Action Text:** Para um editor de texto rico (WYSIWYG) que suporta Markdown e uploads de imagens.
*   **Devise:** Solução flexível para autenticação de usuários.
*   **RSpec:** Framework para testes unitários e de integração.

## 3. Modelos (Models)

Os modelos representam a estrutura de dados da aplicação e a lógica de negócios. Eles interagem diretamente com o banco de dados.

### `User`

Representa um usuário do sistema. Gerenciado pelo Devise.

*   **Atributos:**
    *   `email:string`: Endereço de e-mail do usuário (único).
    *   `encrypted_password:string`: Senha criptografada.
    *   `reset_password_token:string`
    *   `reset_password_sent_at:datetime`
    *   `remember_created_at:datetime`
    *   `created_at:datetime`
    *   `updated_at:datetime`
    *   `admin:boolean`: Indica se o usuário é um administrador (autor do blog). Padrão: `false`.
*   **Associações:**
    *   `has_many :posts, dependent: :destroy`: Um usuário pode ter muitos posts (se for o autor).
    *   `has_many :comments, dependent: :destroy`: Um usuário pode fazer muitos comentários.
*   **Validações:**
    *   `validates :email, presence: true, uniqueness: true`

### `Post`

Representa um post do blog.

*   **Atributos:**
    *   `title:string`: Título do post.
    *   `published_at:datetime`: Data e hora de publicação do post. Se nulo, o post é um rascunho.
    *   `user_id:integer`: Chave estrangeira para o `User` que criou o post.
*   **Associações:**
    *   `belongs_to :user`: Um post pertence a um usuário (o autor).
    *   `has_many :comments, dependent: :destroy`: Um post pode ter muitos comentários.
    *   `has_rich_text :content`: O conteúdo do post é gerenciado pelo Action Text, permitindo rich text e Markdown.
*   **Validações:**
    *   `validates :title, presence: true`
    *   `validates :content, presence: true`

### `Comment`

Representa um comentário em um post.

*   **Atributos:**
    *   `body:text`: Conteúdo do comentário.
    *   `post_id:integer`: Chave estrangeira para o `Post` ao qual o comentário pertence.
    *   `user_id:integer`: Chave estrangeira para o `User` que fez o comentário.
*   **Associações:**
    *   `belongs_to :post`: Um comentário pertence a um post.
    *   `belongs_to :user`: Um comentário pertence a um usuário.
*   **Validações:**
    *   `validates :body, presence: true`

## 4. Controladores (Controllers)

Os controladores processam as requisições dos usuários, interagem com os modelos e renderizam as views.

### `PostsController`

Gerencia a exibição pública dos posts.

*   **`index`:** Exibe uma lista de todos os posts publicados, ordenados pela data de publicação mais recente.
*   **`show`:** Exibe um post individual e seus comentários. Também inclui o formulário para adicionar novos comentários.

### `CommentsController`

Gerencia a criação de comentários.

*   **`create`:** Cria um novo comentário para um post específico. Requer que o usuário esteja autenticado (`before_action :authenticate_user!`). Após a criação, redireciona de volta para a página do post.

### `Admin::PostsController`

Gerencia a criação, edição e exclusão de posts na área administrativa. Apenas usuários com `admin: true` podem acessar.

*   **`index`:** Lista todos os posts (publicados e rascunhos) para o administrador.
*   **`new`:** Exibe o formulário para criar um novo post.
*   **`create`:** Cria um novo post. Associa o post ao `current_user` (o administrador logado).
*   **`edit`:** Exibe o formulário para editar um post existente.
*   **`update`:** Atualiza um post existente.
*   **`destroy`:** Exclui um post.
*   **`before_action :authenticate_user!`:** Garante que apenas usuários logados possam acessar as ações.
*   **`before_action :check_admin`:** Garante que apenas usuários com o atributo `admin` verdadeiro possam acessar as ações. Redireciona para a raiz se o usuário não for um administrador.

## 5. Views

As views são responsáveis por renderizar a interface do usuário. O Tailwind CSS é amplamente utilizado para estilização.

*   **`app/views/layouts/application.html.erb`:** O layout principal da aplicação, incluindo cabeçalho, navegação, botão de troca de tema e rodapé. Utiliza classes do Tailwind para o design responsivo e para os modos claro/escuro.
*   **`app/views/posts/index.html.erb`:** Exibe a lista de posts. Renderiza a partial `_post.html.erb` para cada post.
*   **`app/views/posts/show.html.erb`:** Exibe um post individual. Inclui o conteúdo do post (renderizado pelo Action Text) e a seção de comentários, que renderiza a partial `_comment.html.erb` para cada comentário e a partial `_form.html.erb` para o formulário de novo comentário.
*   **`app/views/posts/_post.html.erb`:** Partial para exibir um resumo de um post na lista.
*   **`app/views/comments/_form.html.erb`:** Partial para o formulário de criação de comentários.
*   **`app/views/comments/_comment.html.erb`:** Partial para exibir um comentário individual.
*   **`app/views/admin/posts/index.html.erb`:** Listagem de posts na área administrativa. Renderiza a partial `_post.html.erb` (da pasta admin) para cada post.
*   **`app/views/admin/posts/_post.html.erb`:** Partial para exibir um post na listagem administrativa, incluindo links para editar e excluir.
*   **`app/views/admin/posts/new.html.erb`:** Formulário para criar um novo post.
*   **`app/views/admin/posts/edit.html.erb`:** Formulário para editar um post existente.
*   **`app/views/admin/posts/_form.html.erb`:** Partial para o formulário de criação/edição de posts, utilizando `form.rich_text_area` para o campo de conteúdo.

## 6. Autenticação e Autorização

O Devise é utilizado para gerenciar a autenticação de usuários. A autorização para a área administrativa é feita através do atributo `admin` no modelo `User`.

*   **Registro/Login:** Usuários podem se registrar e fazer login através das rotas e views geradas pelo Devise.
*   **Admin:** Para tornar um usuário administrador, você pode alterar o atributo `admin` para `true` diretamente no console Rails (`rails c`):

    ```ruby
    user = User.find_by(email: "seu_email@example.com")
    user.update(admin: true)
    ```

## 7. Action Text

O Action Text é integrado para fornecer um editor de texto rico para o campo `content` do modelo `Post`. Ele permite formatação de texto, inserção de links e imagens, e converte automaticamente o Markdown para HTML.

*   A integração é feita adicionando `has_rich_text :content` ao modelo `Post` e usando `form.rich_text_area :content` no formulário.

## 8. Modo Escuro/Claro

A funcionalidade de alternância de tema é implementada usando um controlador Stimulus e classes do Tailwind CSS.

*   **`app/javascript/controllers/theme_controller.js`:** Este controlador Stimulus gerencia a lógica de alternância.
    *   Ele verifica a preferência do sistema (`prefers-color-scheme`) e o `localStorage` do navegador para definir o tema inicial.
    *   O método `toggle()` alterna a classe `dark` no elemento `<html>`, que o Tailwind CSS usa para aplicar os estilos do modo escuro.
    *   A preferência do usuário é salva no `localStorage` para persistência entre as sessões.
*   **`tailwind.config.js`:** Configurado com `darkMode: 'class'` para habilitar a alternância de tema baseada em classes.
*   **`app/views/layouts/application.html.erb`:** O botão de alternância de tema (`data-controller="theme"` e `data-action="theme#toggle"`) está localizado no cabeçalho.

## 9. Testes com RSpec

O RSpec é o framework de teste utilizado no projeto, garantindo a qualidade e a funcionalidade do código.

*   **Testes de Modelo (`spec/models/`):** Verificam as validações e associações dos modelos (`User`, `Post`, `Comment`).
*   **Testes de Requisição (`spec/requests/`):** Testam o comportamento dos controladores e as interações HTTP (por exemplo, criação de comentários, acesso a páginas).

### Como Rodar os Testes

Para rodar todos os testes, execute o seguinte comando no terminal:

```bash
bundle exec rspec
```

## 10. Configuração e Execução da Aplicação

Siga os passos abaixo para configurar e rodar a aplicação em seu ambiente local.

### Pré-requisitos

*   Ruby (versão compatível com Rails 8, e.g., 3.2.x ou superior)
*   Rails 8
*   PostgreSQL
*   Node.js e Yarn/NPM (para assets JavaScript e Tailwind CSS)

### Passos para Configuração

1.  **Clone o Repositório:**

    ```bash
    git clone <URL_DO_SEU_REPOSITORIO>
    cd BlogYcaro
    ```

2.  **Instale as Dependências do Ruby:**

    ```bash
    bundle install
    ```

3.  **Instale as Dependências do JavaScript:**

    ```bash
    npm install
    # ou yarn install, dependendo do seu gerenciador de pacotes
    ```

4.  **Configure o Banco de Dados:**

    Certifique-se de que o PostgreSQL esteja rodando. Se você tiver problemas com o usuário, pode ser necessário criar um usuário no PostgreSQL com o mesmo nome do seu usuário do sistema operacional ou configurar o `config/database.yml` com um usuário e senha específicos.

    ```bash
    # Exemplo para criar um usuário no PostgreSQL (se necessário):
    # sudo -u postgres createuser --superuser SEU_USUARIO_SISTEMA

    rails db:create
    rails db:migrate
    ```

5.  **Crie um Usuário Administrador (Opcional, mas recomendado para gerenciar posts):**

    ```bash
    rails c
    User.create!(email: "seu_email@example.com", password: "sua_senha", password_confirmation: "sua_senha", admin: true)
    exit
    ```

### Executando a Aplicação

Para iniciar o servidor Rails e o processo de build do Tailwind CSS e JavaScript, use o comando `bin/dev` (configurado pelo Rails para usar `foreman` ou similar):

```bash
bin/dev
```

Isso iniciará o servidor web e o processo de build de assets. Você poderá acessar a aplicação em `http://localhost:3000` (ou a porta configurada).

---

Esta documentação serve como um guia abrangente para entender a estrutura, o funcionamento e a manutenção do Blog Pessoal. Para mais detalhes sobre funcionalidades específicas do Rails, Devise, Hotwire ou Tailwind CSS, consulte a documentação oficial de cada ferramenta.