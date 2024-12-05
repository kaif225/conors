pipeline {
 agent none 
 
 stages {
   
   stage('php test') {
      agent {
  docker {
         image 'php:8.2.17-cli-alpine3.18'
         args '--user root'
       }  
 
    }

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

   stage('Code Analysis') {
        agent 'built-in' 
            environment {
                scannerHome = tool 'sonar'
            }
            steps {
                script {
                    withSonarQubeEnv('sonar') {
                        sh "${scannerHome}/bin/sonar-scanner \
                             -Dsonar.projectKey=cronors \
                             -Dsonar.projectName=cronors \
                             -Dsonar.sources=. \
                             -Dsonar.projectVersion=1.0"
                    }
                }
            }
        }
        stage('Quality Gate') {
          agent 'built-in'
            steps {
                script {
                    // Wait for SonarQube analysis to complete and check Quality Gate status
                    timeout(time: 5, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline failed due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }

   

 }


}


