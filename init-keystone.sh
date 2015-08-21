#!/bin/bash

docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ service-create --name=keystone --type=identity --description="Keystone Identity Service"
docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ endpoint-create --service keystone --publicurl 'http://localhost:5000/v2.0' --adminurl 'http://localhost:35357/v2.0' --internalurl 'http://localhost:5000/v2.0'
docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ user-create --name admin --pass password
docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ role-create --name admin
docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ tenant-create --name admin
docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ user-role-add --user admin --role admin --tenant admin

docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ user-create --name demo --pass password
docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ role-create --name _member_
docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ tenant-create --name demo
docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ user-role-add --user demo --role _member_ --tenant demo
docker exec keystone keystone --os-token $ADMIN_TOKEN --os-endpoint http://localhost:35357/v2.0/ tenant-create --name services --description "Services Tenant"

