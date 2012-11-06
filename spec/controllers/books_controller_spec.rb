require 'spec_helper'

describe BooksController do
  render_views
  
  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Add book")
    end
  end  

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
    it "should have the right title" do
      get 'index'
      response.should have_selector("title", 
              :content => "Grinnell Textbook Lending Library | Index")
    end
  end

  describe "POST 'create'" do
    
    describe "failure" do
      before(:each) do
        @attr = {:name => "", :authors => "", :edition => -1}
      end
      
      it "should not create a book" do
        lambda do
          post:create, :book => @attr
        end.should_not change(Book, :count)
      end

      it "should have a failure message" do
        post:create, :book => @attr
        flash[:failure].should =~ /Invalid entry/
      end
    end

    describe "success" do
      before(:each) do
        @attr = {:name => "The Once and Future King", 
          :authors => "T. H. White", :edition => "1"}
      end

      it "should create a book" do
        lambda do
          post:create, :book => @attr
        end.should change(Book, :count).by(1)
      end
      
      it "should redirect to the Add Book page" do
        post:create, :book => @attr
        response.should redirect_to(new_book_path)
      end
      
      it "should have a success message" do
        post:create, :book => @attr
        flash[:success].should =~ /Book successfully added/
      end
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @book = Factory(:book)
    end
    
    it "should destroy the book" do
      lambda do
        delete :destroy, :id => @book
      end.should change(Book, :count).by(-1)
    end

    it "should remain on index page" do
      delete :destroy, :id => @book
      response.should redirect_to(index_path)
    end
  end  
  
  describe "search" do
    before(:each) do
      @attr = {:name => "Art of War", :authors => "Sun Tzu", :edition => 1}
    end
    
    it "should return the book on partial title match" do
      post:create, :book => @attr
      post("rt of Wa")
    end
    
  end
end
