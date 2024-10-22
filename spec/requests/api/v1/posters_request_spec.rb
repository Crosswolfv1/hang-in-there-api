require 'rails_helper'

describe "poster api" do
  it "sends a list of posters" do
    Poster.create(  
      name: "poster1",
      description: "stuff.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"  
    )

    Poster.create(
      name: "poster 2",
      description: "more stuff.",
      price: 68.00,
      year: 2019,
      vintage: true,
      img_url:  "https://images.unsplash.com/photo-1620401537439-98e94c004b0d"
    )

    Poster.create(  
      name: "poster 3",
      description: "stuff boogaloo.",
      price: 127.00,
      year: 2021,
      vintage: false,
      img_url:  "https://images.unsplash.com/photo-1551993005-75c4131b6bd8"
    )

    get '/api/v1/posters'

    posters = JSON.parse(response.body, symbolize_names: true)

    expect(posters.count).to eq(3)

    posters.each do |poster|
      expect(poster).to have_key(:id)
      expect(poster[:id]).to be_an(Integer)

      expect(poster).to have_key(:name)
      expect(poster[:name]).to be_a(String)

      expect(poster).to have_key(:description)
      expect(poster[:description]).to be_a(String)

      expect(poster).to have_key(:price)
      expect(poster[:price]).to be_a(Float)

      expect(poster).to have_key(:year)
      expect(poster[:year]).to be_a(Integer)

      expect(poster).to have_key(:vintage)
      expect(poster[:vintage]).to be(true).or be(false)

      expect(poster).to have_key(:img_url)
      expect(poster[:img_url]).to be_a(String)
    end
  end

  it "sends one poster by id" do 
    Poster.create(  
      name: "poster1",
      description: "stuff.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"  
    )

    Poster.create(
      name: "poster 2",
      description: "more stuff.",
      price: 68.00,
      year: 2019,
      vintage: true,
      img_url:  "https://images.unsplash.com/photo-1620401537439-98e94c004b0d"
    )

    Poster.create(  
      name: "poster 3",
      description: "stuff boogaloo.",
      price: 127.00,
      year: 2021,
      vintage: false,
      img_url:  "https://images.unsplash.com/photo-1551993005-75c4131b6bd8"
    )

    id = (Poster.create(  
      name: "poster 3",
      description: "stuff boogaloo.",
      price: 127.00,
      year: 2021,
      vintage: false,
      img_url:  "https://images.unsplash.com/photo-1551993005-75c4131b6bd8"
    ).id)

    get "/api/v1/posters/#{id}"

    poster = JSON.parse(response.body, symbolize_names: true)

    expect(poster).to have_key(:id)
    expect(poster[:id]).to be_an(Integer)
    expect(poster[:id]).to eq(id)
    expect(poster[:name]).to eq("poster 3")
  end
end
