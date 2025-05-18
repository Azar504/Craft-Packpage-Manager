# Craft - Gerenciador de Pacotes para Termux

![Termux](https://img.shields.io/badge/Termux-000000?style=for-the-badge&logo=termux&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-121011?style=for-the-badge&logo=gnubash&logoColor=white)
![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
![C](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)
![C%23](https://img.shields.io/badge/C%23-239120?style=for-the-badge&logo=c-sharp&logoColor=white)
![.NET](https://img.shields.io/badge/.NET-512BD4?style=for-the-badge&logo=.net&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

---

## Descrição

Craft é um gerenciador de pacotes modular e seguro para Termux. Automatiza instalações, gerencia permissões, e suporta extensões via plugins.

---

## Funcionalidades

- Arquitetura modular: Shell, Ruby, C, C#/.NET.
- Sistema de permissões: níveis user/admin/system.
- Automação: dependências, fallback e rollback.
- Suporte a linguagens e ferramentas diversas.
- Plugins dinâmicos com sandbox.
- Interface clara, colorida e script-friendly.

---

## Exemplo de Uso

```bash
craft install zig --optimize
```

---

## Estrutura

```
craft.sh              # Script principal
ruby/craft-core.rb    # Lógica Ruby
src/craft_core.c      # Core em C
src/craft_core.cs     # Componentes .NET
plugins/              # Plugins
Makefile              # Build
docs/                 # Documentação

```

---

## Requisitos

- Termux

- Ruby 2.7+

- .NET Core SDK

- Compilador C

- Git

- ARMv7 e ARMv8



---

## Comandos

```craft install <pacote>```

```craft update-self```

```craft audit```

```craft package create```

```craft --debug```



---

## Licença

**BSD 2-Clause License (em português).**


---

## Repositório

``https://github.com/IBSP-Labs/Craft-Packpage-Manager``
