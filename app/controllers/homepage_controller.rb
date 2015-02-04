class HomepageController < ApplicationController

	def index
		loadValues
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
		for i in 0..@cart_items.size-1
			product_cost = Item.find_by(id: @cart_items[i].item_id)
			@total_price+= (@cart_items[i].quantity)
		end
		return @user_cart_items
	end

	def loadValues
		getCart
		getAllItems
	end

end
