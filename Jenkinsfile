pipeline {
 agent {
  docker {
         image 'php:8.2.17-cli-alpine3.18'
         args '--user root'
     }  
 
 }
 
 stages {
   stage('checkout repo') {
     steps {
       checkout scm
     
     }
   
   }
   
   
   stage('php test') {
     steps {
       sh """
          composer install && \
          php artisan test
         
          """
       
       
     
     
     }
   
   
   }
 
 }


}