def find_item_by_name_in_collection(name, collection)
  
  i = 0
  while i < collection.length do
    if name === collection[i][:item] 
      return collection[i]
    else
      i += 1
    end
  end 
end

def consolidate_cart(cart)
  
  cons_cart = []

  i = 0
  while i < cart.length do
    name = cart[i][:item]
    item_being_searched = find_item_by_name_in_collection(name, cons_cart)
    if item_being_searched
     item_being_searched[:count] += 1
    else
      cart[i][:count] = 1
      cons_cart.push(cart[i])
    end
    i += 1
  end
  cons_cart
end
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.


def coupon_hash(coupon)
  coupon_item_price = (coupon[:cost].to_f / coupon[:num]).round(2)
  {
    :item => "#{coupon[:item]} W/COUPON",
    :price => coupon_item_price,
    :count => coupon[:num]
  }
end

def apply_coupon_to_cart(original_item, coupon, cart)
  original_item[:count] -= coupon[:num]
  item_with_coupon = coupon_hash(coupon)
  item_with_coupon[:clearance] = original_item[:clearance]
  cart.push(item_with_coupon)
end


def apply_coupons(cart, coupons)
  
  i = 0
  while i < coupons.length do
    coupon = coupons[i]
    item_with_coupon = find_item_by_name_in_collection(coupon[:item], cart)
    item_is_in_cart = !!item_with_coupon
    enough_items_to_apply_coupon = item_is_in_cart && item_with_coupon[:count] >= coupon[:num]
      if item_is_in_cart && enough_items_to_apply_coupon
        apply_coupon_to_cart(item_with_coupon, coupon, cart)
      end
      i += 1
  end
  cart
end
  # REMEMBER: This method **should** update cart


def apply_clearance(cart)
  
  i = 0
  while i < cart.length do
    item = cart[i]
    if item[:clearance]
      item[:price] = (item[:price] * 0.8).round(2)
    end
    i += 1
  end
  cart
end
  # REMEMBER: This method **should** update cart


def checkout(cart, coupons)
  total = 0 
  
  consolidated_cart = consolidate_cart(cart)
  apply_coupons(consolidated_cart, coupons)
  apply_clearance(consolidated_cart)
  
  i = 0
  while i < consolidated_cart.length do
    total += (consolidated_cart[i][:price] * consolidated_cart[i][:count])
    i += 1
  end
  if total > 100
    total = (total * 0.9)
  end
  total
end
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers

