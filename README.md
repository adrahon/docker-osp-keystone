# docker-osp-keystone

OpenStack Keystone on Docker using RDO on CentOS.

## Usage

Requires MariaDB and RabbitMQ. Instructions below assume they are also running as containers.

### Create keystone database and user

    docker exec mariadb mysql -e "create database keystone;"
    docker exec mariadb mysql -e "GRANT ALL ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'password';"
    docker exec mariadb mysql -e "GRANT ALL ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'password';"
    docker exec mariadb mysql -e "flush privileges;"

### Launch keystone container

    export ADMIN_TOKEN=$(openssl rand -hex 10)
    docker run -d --link mariadb:dbhost --link rabbitmq:rabbithost --env BOOTSTRAP=1 --env ADMIN_TOKEN=$ADMIN_TOKEN -p 5000:5000 --name keystone  osp-keystone

### Create base services and users in keystone

    docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ service-create --name=keystone --            type=identity --description="Keystone Identity Service"
    docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ endpoint-create --service keystone --        publicurl 'http://localhost:5000/v2.0' --adminurl 'http://localhost:35357/v2.0' --internalurl 'http://localhost:5000/v2.0'
    docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ user-create --name admin --pass password
    docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ role-create --name admin
    docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ tenant-create --name admin
    docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ user-role-add --user admin --role admin --   tenant admin

    docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ user-create --name demo --pass password
    docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ role-create --name _member_
    docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ tenant-create --name demo
    docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ user-role-add --user demo --role _member_ -- tenant demo
    docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ tenant-create --name services --description  "Services Tenant"

Test that it's working from the host (you need the openstack client)

    openstack --os-username demo --os-password password --os-project-name demo --os-auth-url http://localhost:5000/v2.0/ token create

