# ✅ Areco Tasks - Gerenciador de Tarefas (Flutter + .NET)

Este projeto é um Sistema de Gerenciamento de Tarefas completo, construído com **Flutter** (Front-end Mobile) e **.NET 8 Web API** (Back-end), utilizando **SQLite** como banco de dados local.

É um projeto ideal para avaliação de lógica de programação, arquitetura de software e integração entre um aplicativo móvel e uma API RESTful.


## 🏗️ Tecnologias Utilizadas

| Camada | Tecnologia |
| :--- | :--- |
| **Mobile App** | Flutter 3.x + Dart |
| **Backend** | .NET 8 Web API |
| **Banco** | SQLite (arquivo `areco.db` criado automaticamente) |
| **ORM** | Entity Framework Core |
| **Autenticação** | Login com hash Bcrypt |
| **Arm. Local (App)** | SharedPreferences (Flutter) |
| **API Docs** | Swagger UI (embutido) |

---

## 📌 Funcionalidades

### ✅ APP (Flutter)
* Login e Registro de usuários
* Home com listagem de tarefas
* CRUD completo de tarefas (Adicionar, Editar, Excluir)
* Filtros por status e intervalo de datas
* Tela de perfil com dados do usuário (puxados da API)

<img width="412" height="853" alt="loginareco" src="https://github.com/user-attachments/assets/55046981-07ba-4bc0-951f-9bf8388f808e" /> <img width="402" height="850" alt="homeareco" src="https://github.com/user-attachments/assets/91e0f283-e4df-4f9f-9d2e-6d6eab2392c7" />



### ✅ API (.NET)
* Endpoints para Registro, Login de usuários
* CRUD completo de tarefas
* Validação de datas e regras de negócio (ex: Apenas tarefas "A Realizar" podem ser excluídas)
* Armazenamento de senhas com hash **Bcrypt**
* Geração automática do banco `areco.db` via EF Core Migrations

---

## 🚀 Como Rodar o Projeto

Para rodar o projeto completo, você precisará de dois terminais: um para o Backend e outro para o App.

### 1. Backend (.NET API)

1.  Navegue até a pasta da API:
    ```bash
    cd areco_api/Areco.Api
    ```
2.  Restaure as dependências do .NET:
    ```bash
    dotnet restore
    ```
3.  Aplique as migrações (isso criará o banco `areco.db`):
    ```bash
    dotnet ef database update
    ```
4.  Inicie a API:
    ```bash
    dotnet run
    ```
5.  A API estará disponível e o Swagger pode ser acessado em:
    **`http://localhost:5081/swagger/index.html`**

### 2. App (Flutter)

1.  Navegue até a pasta do aplicativo:
    ```bash
    cd areco_application
    ```
2.  Restaure as dependências do Flutter:
    ```bash
    flutter pub get
    ```
3.  Execute o aplicativo (com um Emulador Android aberto):
    ```bash
    flutter run
    ```

> **⚠️ Atenção: Configuração da API (IP/URL)**
> O app está pré-configurado para apontar para `10.0.2.2:5081` (IP padrão do Emulador Android para o `localhost` da máquina).
>
> Se for rodar o app em outro ambiente (como **Web** ou **iOS**), você precisará alterar a URL da API manualmente nos seguintes arquivos:
> * `areco_application/lib/services/auth_service.dart`
> * `areco_application/lib/services/task_service.dart`
>
> **Exemplo (Testando na Web):**
> * **Mudar de:** `http://10.0.2.2:5081/api/Auth/login`
> * **Mudar para:** `http://localhost:5081/api/Auth/login`

---

## 🧪 Como Testar (Guia p/ Recrutador)

1.  **Clone** o repositório.
2.  Siga os passos da seção "Como Rodar o Projeto" para iniciar o **Backend** e o **App**.
3.  Confirme que o Swagger (`http://localhost:5081/swagger`) está no ar. ✅
4.  No aplicativo, use a tela de **Registro** para criar um novo usuário.
    * *Opcional: Use o usuário de teste abaixo se preferir criar via API.*
5.  Faça **Login** com o novo usuário.
6.  Na tela Home, **crie** algumas tarefas.
7.  Teste os **filtros** (por status e data).
8.  **Edite** e **exclua** tarefas (teste a regra de não poder excluir tarefas que não estejam "A Realizar").
9.  Vá para a tela de **Perfil** e verifique se os dados do usuário (puxados do endpoint `/api/Auth/me`) estão corretos.
10. Faça **Logout** e feche o app. Ao reabrir, verifique se ele pede o login novamente (testando a persistência de sessão).

### 🔑 Usuário de Teste (Opcional)
  "email": "victor@areco.com",
  "password": "admin"


### Melhorias

Melhorar a segurança do aplicativo, adicionar JWT e Refresh Token e um enviroment privado para dados da API.
