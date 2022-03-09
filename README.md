# Carom

[![01. Checkout, Build And Push to jFrog on-prem and jFrog on-cloud](https://github.com/McK-Internal/MDE_ProposeToWin-carom/actions/workflows/01_build_and_push_docker_image.yml/badge.svg)](https://github.com/McK-Internal/MDE_ProposeToWin-carom/actions/workflows/01_build_and_push_docker_image.yml)
[![02. Deploy on on-prem K8s integration](https://github.com/McK-Internal/MDE_ProposeToWin-carom/actions/workflows/02_deploy_on_onprem_k8s_integration.yml/badge.svg)](https://github.com/McK-Internal/MDE_ProposeToWin-carom/actions/workflows/02_deploy_on_onprem_k8s_integration.yml)

# How to run the application via docker (standalone)
1. To build and run web and db containers 
    
    ```docker-compose up```

2. To seed the data (required after first run) 
    
    ```docker-compose exec web rake db:seed```

3. To bring all the containers down 
    
    ```docker-compose down```

4. To build only web containers 
    
    ```docker-compose -f docker-compose-standalone.yml build web```

5. To bring up db instance only 
    
    ```docker-compose up db```

6. To execute rails console 
    
    ```docker-compose exec web rails console```

6. To execute rails dbconsole 
    
    ```docker-compose exec web rails dbconsole```

7. To get shell access on web 
    
    ```docker-compose exec web sh```

8. To access db's mysql over host 
    
    ```mysql -u root -proot -h 127.0.0.1 -P 3307```
    