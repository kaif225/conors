pipeline {
 agent {
  docker {
         image 'php:8.2.17-cli-alpine3.18'
         args '--user root'
     }  
 
 }
 
 stages {
  //testin
   stage('checkout repo') {
     steps {
       checkout scm
     
     }
   
   }
   
   
   stage('php test') {
     steps {
       sh """
          curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
          composer config --no-plugins allow-plugins.phpstan/extension-installer true && \
          composer install --no-interaction --prefer-dist && \
          php artisan test
         
          """
       
       
     
     
     }
   
   
   }
 
 }


}
