mv terraform.tfvars.example terraform.tfvars

Получить токен: https://cloud.yandex.ru/docs/cli/quickstart

Узнать 
  - cloud-id:  yc resource-manager cloud list
  - folder-id: yc resource-manager folder list

Всё что нужно для блока provider: yc config list

Получить список всех доступных идентификаторов стандартных образов:
yc compute image list --folder-id standard-images
