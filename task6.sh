# 1. Скачиваем образ (если ещё нет)
docker pull hashicorp/terraform:latest

# 2. Устанавливаем dive (один раз)
sudo pacman -S dive                     # у тебя уже есть

# 3. Ищем слой, где лежит /bin/terraform
dive hashicorp/terraform:latest
# → в dive: жмёшь F → вводишь /bin/terraform → Enter → скриншот

# 4. Самый правильный способ — через docker cp
docker run -d --name tf-temp hashicorp/terraform:latest sleep 3600
docker cp tf-temp:/bin/terraform ~/terraform_from_image
docker rm -f tf-temp
chmod +x ~/terraform_from_image
~/terraform_from_image version