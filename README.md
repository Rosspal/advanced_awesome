# AdvancedAwesome

Проект для наглядного отображения awesome библиотек на Elixir.

## Быстрый запуск
Переменные нужно указать в файле `.local.env`, в частности необходимо указать `GITHUB_TOKEN`.  
[Инструкция](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) по получению токена.  
Может отображать библиотеки и из других awesome листов: [python](https://github.com/vinta/awesome-python), [erlang](https://github.com/drobakowski/awesome-erlang#readme), [javaScript](https://github.com/sorrycc/awesome-javascript#readme) и тд.

Запуск контейнера c Postgres

```
make up
```

Для запуска тестов

```
make test
```

Для локального запуска в режиме разработчика

```
make iex-server
```

Завершить контейнер с Postgres

```
make down
```
