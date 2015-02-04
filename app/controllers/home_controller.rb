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

	def getAllItems
		@all_items = Item.all()
		return @all_items
	end


	def getCart
		cart = Cart.find_by(user_id: current_user.id)
		@cart_items = CartItem.where(cart_id: cart.id)
		# @user_cart_items = Array.new(cart_items.size)
		# for i in 0..cart_items.size-1
		# 	@user_cart_items[i] = CartItem.where()
		@total_price=0
		# for i in 0..@cart_items.size-1
		# 	product_cost = Item.find_by(id: @cart_items[i].item_id)
		# end
		@cart_items_data = Array.new(@cart_items.size)
		for i in 0..@cart_items.length-1
			@cart_items_data[i] = Item.find_by(id: @cart_items[i].item_id)
			if @cart_items_data[i] == nil
				logger.info "AWWWWWWWWWWWW"
				logger.info @cart_items[i].id
				logger.info "AWWWWWWWWWWWW"
			else
				@total_price= (@total_price + (@cart_items[i].quantity* (@cart_items_data[i].price)))
			end
		end

		return @user_cart_items,@cart_items_data,@total_price
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

		redirect_to :back
		# reloadvariables
	end

	def clearcart
		cart = Cart.find_by(user_id: current_user.id)
		cart_items = CartItem.where(cart_id:cart.id)
		cart_items.each do |c|
			# item = Item.find_by(id:c.item_id)
			# item.update(qty:item.qty+c.item_qty)
			c.destroy		
		end
		redirect_to :back
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

		getCart
		getAllItems
		render 'app/views/homepage/index.html.erb'
	end

end