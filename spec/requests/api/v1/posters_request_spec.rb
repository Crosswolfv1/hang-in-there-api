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

    expect(posters[:data].count).to eq(3)

    posters[:data].each do |poster|

      expect(poster).to have_key(:id)
      expect(poster[:id]).to be_an(Integer)

      expect(poster[:attributes]).to have_key(:name)
      expect(poster[:attributes][:name]).to be_a(String)

      expect(poster[:attributes]).to have_key(:description)
      expect(poster[:attributes][:description]).to be_a(String)

      expect(poster[:attributes]).to have_key(:price)
      expect(poster[:attributes][:price]).to be_a(Float)

      expect(poster[:attributes]).to have_key(:year)
      expect(poster[:attributes][:year]).to be_a(Integer)

      expect(poster[:attributes]).to have_key(:vintage)
      expect(poster[:attributes][:vintage]).to be(true).or be(false)

      expect(poster[:attributes]).to have_key(:img_url)
      expect(poster[:attributes][:img_url]).to be_a(String)
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

    expect(poster[:data]).to have_key(:id)
    expect(poster[:data][:id]).to be_an(Integer)

    expect(poster[:data][:attributes]).to have_key(:name)
    expect(poster[:data][:attributes][:name]).to eq("poster 3")

  end

  it "updates an existing poster" do
    id = Poster.create(  
      name: "poster1",
      description: "stuff.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"  
    ).id

    id2 =     Poster.create(
      name: "poster 2",
      description: "more stuff.",
      price: 68.00,
      year: 2019,
      vintage: true,
      img_url:  "https://images.unsplash.com/photo-1620401537439-98e94c004b0d"
    ).id

    get "/api/v1/posters/#{id}"
    poster_base = JSON.parse(response.body, symbolize_names: true)

    get "/api/v1/posters/#{id2}"
    poster2_base = JSON.parse(response.body, symbolize_names: true)

    updated_attributes = {
      name: "updated poster",
      price: 69.69
    }

    patch "/api/v1/posters/#{id}", params: { poster: updated_attributes}

    poster_update = JSON.parse(response.body, symbolize_names: true)

    get "/api/v1/posters/#{id2}"
    poster2_base_post_update = JSON.parse(response.body, symbolize_names: true)


    expect(poster_base[:data][:attributes][:name]).not_to eq(poster_update[:data][:attributes][:name])
    expect(poster_base[:data][:attributes][:price]).not_to eq(poster_update[:data][:attributes][:price])
    
    expect(poster_base[:data][:attributes][:year]).to eq(poster_update[:data][:attributes][:year])
    expect(poster_base[:data][:attributes][:vintage]).to eq(poster_update[:data][:attributes][:vintage])
    expect(poster_base[:data][:attributes][:description]).to eq(poster_update[:data][:attributes][:description])

    expect(poster2_base_post_update[:data][:attributes][:name]).to eq(poster2_base[:data][:attributes][:name])
    expect(poster2_base_post_update[:data][:attributes][:price]).to eq(poster2_base[:data][:attributes][:price])
    expect(poster2_base_post_update[:data][:attributes][:year]).to eq(poster2_base[:data][:attributes][:year])
    expect(poster2_base_post_update[:data][:attributes][:vintage]).to eq(poster2_base[:data][:attributes][:vintage])
    expect(poster2_base_post_update[:data][:attributes][:description]).to eq(poster2_base[:data][:attributes][:description])
  end

  it "DESTROYS and existing poster" do

    id = Poster.create(  
      name: "poster1",
      description: "stuff.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"  
    ).id

    id2 = Poster.create(
      name: "poster 2",
      description: "more stuff.",
      price: 68.00,
      year: 2019,
      vintage: true,
      img_url:  "https://images.unsplash.com/photo-1620401537439-98e94c004b0d"
    ).id

    expect(Poster.exists?(id: id)).to be true
    expect(Poster.exists?(id: id2)).to be true

    delete "/api/v1/posters/#{id}"

    expect(response).to have_http_status(200)

    expect(Poster.exists?(id: id)).to be false
    expect(Poster.exists?(id: id2)).to be true
  end

  it "CREATES new posters" do 

    create "/api/v1/posters/", params: {  name: "poster1",
    description: "stuff.",
    price: 89.00,
    year: 2018,
    vintage: true,
    img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"  }

    create "api/v1/poster/", params: {  name: "poster 2",
    description: "more stuff.",
    price: 68.00,
    year: 2019,
    vintage: true,
    img_url:  "https://images.unsplash.com/photo-1620401537439-98e94c004b0d"}

    expect(response).to have_http_status(200)
  end
end
