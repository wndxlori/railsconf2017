schema "0001 initial" do

  entity "Film" do
    string :title, optional: false
  	integer32 :episode_id, optional: false
  	string :opening_crawl, optional: false
  	string :director, optional: false
  	string :producer, optional: false
  	datetime :release_date, optional: false
  	string :url, optional: false
  end

  entity "Person" do
    string :name, optional: false
    string :height, optional: false
    string :mass, optional: false
    string :hair_color, optional: false
  	string :skin_color, optional: false
  	string :eye_color, optional: false
  	string :birth_year, optional: false
  	string :gender, optional: false
  	string :homeworld, optional: false
  	string :url, optional: false
  end

  # Examples:
  #
  # entity "Person" do
  #   string :name, optional: false
  #
  #   has_many :posts
  # end
  #
  # entity "Post" do
  #   string :title, optional: false
  #   string :body
  #
  #   datetime :created_at
  #   datetime :updated_at
  #
  #   has_many :replies, inverse: "Post.parent"
  #   belongs_to :parent, inverse: "Post.replies"
  #
  #   belongs_to :person
  # end

end
