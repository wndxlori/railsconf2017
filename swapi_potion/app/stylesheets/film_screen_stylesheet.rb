class FilmScreenStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed,
  # example: include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def title_label(st)
    st.font = font.system(24)
    st.frame = { top: 100, left: 20, fr: 20, height: 40}
  end

  def name_label(st)
    st.frame = { below_prev: 10, left: 20, fr: 20, height: 30}
  end

  def date_label(st)
    st.frame = { below_prev: 10, left: 20, fr: 20, height: 30}
  end

  def crawl_text(st)
    st.frame = { below_prev: 10, left: 20, fr: 20, fb: 20}
  end
end
