class HomeController < ApplicationController
	before_action :authenticate_user!
	def index
    	logger.info "index!!!!!!!"
		cart = Cart.find_by(user_id: current_user.id)
		if cart == nil
		    cart = Cart.create(user_id: current_user.id)
		    cart.save
		    logger.info "created!!"
    	end
    	reloadvariables
	end

	def addtocart
		logger.info "index!!!!!!!"

		cart = Cart.find_by(user_id: current_user.id)
		if cart == nil
		    cart = Cart.create(user_id: current_user.id)
		    cart.save
		    logger.info "created!!"
    	end
		cart_item = CartItem.find_by(cart_id:cart.id, item_id: params[:item_id])
		if cart_item == nil
			cart_item = CartItem.create(cart_id:cart.id, item_id:params[:item_id], quantity:1)
		else
			cart_item.update(quantity:cart_item.quantity+1)
		end

		# item = Item.find_by(id:params[:item_id])
		# item.update(qty:item.qty-1)


		reloadvariables
	end

	def reloadvariables
		@all_items = Item.all
		cart = Cart.find_by(user_id: current_user.email)
		if cart == nil
		    cart = Cart.create(user_id: current_user.id)
		    cart.save
		    logger.info "created!!"
    	end
		@user_cart_items = CartItem.where(cart_id: cart.id)

		render 'app/views/homepage/index.html.erb'
	end

end