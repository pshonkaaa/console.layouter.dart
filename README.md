## INFO

layouter - консольная утилита для быстрого редактирования структуры проекта

## SETUP

#### Активировать

    dart pub global activate --source path /Users/pshonka/_dev/projects/dart/consoles/console.layouter.dart

#### Или
    
    dart pub global activate --source git https://github.com/pshonkaaa/console.layouter.dart


#### Создать структуру в pubspec.yaml

```yaml
layouter:
    layout:
        # Список приложений. К примеру разрабатываем расширение для браузера.
        # Указываем:
        #   background - для фонового скрипта 
        #   injected - для встраиваемого скрипта
        apps:
            background:
                # Не обязательно
                # sides:

            injected:
                # Список сторон. К примеру разрабатываем расширение для браузера.
                # Указываем:
                #   dart - для логики на языке Dart(core, ui)
                #   javascript - для реализации взаимодействия со встраиваемой страницей
                sides:
                  - dart
                  - javascript
```


## HOW TO USE

    Вывести список доступных команд
    > layouter -h

    Создать разметку для приложения
    > layouter app create [app_name]

    Добавить модуль
    > layouter module add [module_name] 
        --app=[app_name] - необязательно, если приложение одно
        --side=[side_name] - необязательно, если сторон нет

    Добавить экран
    > layouter page add [page_name] 
        --app=[app_name] - необязательно, если приложение одно
        --side=[side_name] - необязательно, если сторон нет