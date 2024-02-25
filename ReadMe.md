
# 初回起動
docker compose up  -d   
# 再起動
docker-compose down                
docker-compose up -d

#　トランザクションログの平文化
docker exec run-php-db mysqlbinlog　./MySQL/mysql/

