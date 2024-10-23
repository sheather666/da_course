# Шпаргалка по git
## Базовые команды bash
- pwd (print working directory) - команда, выводящая путь к текущей директории
- cd (change directory) - команда, с помощью которой можно сменить директорию
- ls (list directory contents) - команда, отображающая содержимое директории
- touch - команда для создания файлов
- mkdir - команда для создания директорий
- cp - команда для копирования файлов
- mv - команда для перемещения файлов и папок
- cat - команда для чтения содержимого файла в консоль
- rm - команда для удаления файла
- rmdir - команда для удаления директории

## Базовые команды GIT
- git version - команда, отображающая текущую версию Git, установленную на компьютере;
- git config --global user.name "first_name last_name" - команда для указания имени или никнейма 
- git config --global user.email example@gmail.com - команда для указания имейла пользователя в файле .gitconfig
- git init - команда, для преобразования текущей директории в репозиторий
- rm -rf .git - команда, для "разгичивания" директории. Т.е. если нужно чтобы папка перестала быть репозиторием
- git status - показывает текущее состояние репозитория
- git add - команда, для подготовки файлов к сохранению в репозитории
- git commit -m - делаем коммит с сопроводительным комментарием
- git log - выводит историю коммитов