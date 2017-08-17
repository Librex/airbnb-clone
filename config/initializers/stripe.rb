    Rails.configuration.stripe = {
      :publishable_key => 'pk_test_1eufCmdPHWZ87wFkrRyRxQSb',
     
      :secret_key      => 'sk_test_zquU0vm94WWcGpYr2T9FD5Eg'
     
    }
     
    Stripe.api_key = Rails.configuration.stripe[:secret_key]

