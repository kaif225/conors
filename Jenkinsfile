pipeline {
 agent {
  docker {
         image 'php:8.2.17-cli-alpine3.18'
         args '--user root'
     }  
 
 }
 
  environment {
        GIT_REF = sh(script: "git describe --tags --exact-match", returnStdout: true).trim()
    }

 
 stages {
  //testin
  //ssakl
   stage('see the envs') {
    steps {
       sh 'env'
    }
   }
   
    stage('Check Tag') {
            when {
                expression {
                    return env.GIT_REF?.startsWith('v')
                }
            }
            steps {
                echo "Tag created: ${env.GIT_REF}, starting with 'v'. Running pipeline."
            }
        }


   stage('php test') {
     steps {
       sh """
          apk update && apk add git && \
          cp .env.example .env && \
          curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
          composer config --no-plugins allow-plugins.phpstan/extension-installer true && \
          composer install --no-interaction --prefer-dist && \
          php artisan key:generate && \
          php artisan test 

         
          """
       
       
     
     
     }
   
   
   }

 }


}


