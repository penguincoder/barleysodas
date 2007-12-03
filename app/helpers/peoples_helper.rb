module PeoplesHelper
  def new_people_link
    link_to 'Sign Up!', new_people_path, { :title => 'Sign Up!' }
  end
  
  def show_people_link(people)
    link_to people.title, people_path(people.page.title_for_url),
      { :title => people.title }
  end
  
  def edit_people_link(people)
    link_to 'Edit People', edit_people_path(people.page.title_for_url),
      { :title => "Edit #{people.title}" }
  end
end
