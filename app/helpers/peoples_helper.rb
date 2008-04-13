module PeoplesHelper
  def new_people_link
    link_to 'Sign Up!', new_people_path, { :title => 'Sign Up!' }
  end
  
  def show_people_link(people)
    link_to people.title, people_path(people), { :title => people.title }
  end
  
  def edit_people_link(people)
    link_to 'Edit People', edit_people_path(people),
      { :title => "Edit #{people.title}" }
  end
  
  def show_friends_link(people)
    link_to "#{people.title}'s Friends (#{people.actual_friends.size})",
      friend_path(people)
  end
  
  def add_friend_link(people)
    link_to "#{image_tag('list-add.png')} Friend",
      friends_path('friend[source_id]' => session[:people_id],
      'friend[destination_id]' => people.id), :method => :post
  end
  
  def remove_friend_link(people)
    link_to "#{image_tag('list-remove.png')} Friend",
      friend_url(people, :d => session[:people_id]), :method => :delete
  end
end
