pipeline {
 agent {
  docker {
         image 'php:8.2.17-cli-alpine3.18'
         args '--user root'
     }  
 
 }
 
 
 stages {
     //asASAs
     //asdkasdlk
   stage('see the envs') {
    steps {
       sh 'env'
       sh "apk update && apk add git"
       script {
                    // Get the Git ref and assign it to env.GIT_REF
                    env.GIT_REF = sh(script: "git describe --tags", returnStdout: true).trim()
                    echo "GIT_REF set to: ${env.GIT_REF}"
                }
    }
   }
     
    stage('debug') {
        steps {
            echo "GIT_REF value: ${env.GIT_REF}"
        }
    } 
    stage('Check Tag') {
            when {
                expression {
                    return env.GIT_REF && env.GIT_REF.startsWith('v')
                }
            }
            steps {
                echo "Tag created: ${env.GIT_REF}, starting with 'v'. Running pipeline."
            }
        }


   stage('php test') {
     steps {
       sh """
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


