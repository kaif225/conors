pipeline {
 agent {
  docker {
         image 'php:8.2.17-cli-alpine3.18'
         args '--user root'
     }  
 
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
                    // Check if the ref is a tag and if it starts with 'v'
                    return (env.GIT_REF?.startsWith('refs/tags/v'))
                }
            }
            steps {
                echo "Tag created: ${env.GIT_REF}, starting with 'v'. Running pipeline."
                // Your steps here, e.g., building or deploying based on the tag
            }
        }

        stage('Other Tasks') {
            when {
                not {
                    expression {
                        // If the tag does not start with 'v', do not proceed
                        return (env.GIT_REF?.startsWith('refs/tags/v'))
                    }
                }
            }
            steps {
                echo "Not a tag starting with 'v'. Skipping further pipeline execution."
            }
        



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

}
