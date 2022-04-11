class UsersController < ApplicationController
    # POST /Signup
    def create
        
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    rescue ActiveRecord::RecordInvalid => exception
        # exception.record is the user the exception was raised on
        # exception.record.errors = #<ActiveModel::Errors:0x00007fcd15ec2c70 @base=#<User id: nil, username: nil, password_digest: nil, created_at: nil, updated_at: nil>, @errors=[#<ActiveModel::Error attribute=password, type=blank, options={}>]>
        # exception.record.errors.full_messages = ["Password can't be blank"]
        render json: { errors: exception }, status: :unprocessable_entity
    end

    # GET /me
    def show
        if session[:user_id]
            render json: User.find(session[:user_id]), status: :ok
        else
            render json: { error: "User not logged in" }, status: :unauthorized
        end
    end

    private

    def user_params
        params[:username] = params[:name]
        params.permit(:username, :password, :password_confirmation)
    end
end
