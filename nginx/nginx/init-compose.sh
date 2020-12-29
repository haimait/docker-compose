#!/bin/bash
docker run -d --name nginxtest nginx  #启动一个nginx容器
docker cp nginxtest:/etc/nginx ./  #复制容器里的nginx目录到当前目录
docker rm -f nginxtest #停止并删除nginx容器

#修改default.conf配置文件
tee $PWD/nginx/conf.d/default.conf<<-'EOF'
server {

    listen       80;

    server_name  localhost;
    
    access_log  /var/log/nginx/localhost.access.log;
    error_log   /var/log/nginx/localhost.error.log;
    
    # 配置前端静态文件目录
    
    location / {
        root  /wwwroot/html;
        index  index.html index.htm index.php;
    }
    
    #location ~ \.php$ {
    #    fastcgi_pass   myphp73-fpm:9000; #myphp73-fpm容器的名字
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
    #    include        fastcgi_params;
    #}
    
    # 配置后台go服务api接口服务 代理到8877端口  
    #location ~ ^/goadminapi/ {
    #    proxy_set_header   Host             $http_host;
    #    proxy_set_header   X-Real-IP        $remote_addr;
    #    proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    #    proxy_set_header   X-Forwarded-Proto  $scheme;
    #    rewrite ^/goadminapi/(.*)$ /$1 break;
    #    proxy_pass  http://127.0.0.1:8877;   
    #    }
}

EOF

#新建html目录
mkdir -p /wwwroot/html

#新建index.html文件
tee /wwwroot/html/index.html<<-'EOF'
hello /wwwroot/html/index.html haimait

EOF

#启动服务
docker-compose up -d
