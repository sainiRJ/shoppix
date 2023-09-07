class PaymentsController < ApplicationController
    def create
        @course = Course.find(params[:course_id])
        token = params[:stripeToken]
    
        begin
          charge = Stripe::Charge.create(
            amount: @course.price * 100, # Convert to cents
            currency: 'inr',
            source: token,
            description: 'Course purchase'
          )
    
          # Handle successful payment (e.g., update user's course access)
          # Redirect to a success page or display a success message.
        rescue Stripe::CardError => e
          flash[:error] = e.message
          redirect_to course_path(@course)
        end
      end
end
