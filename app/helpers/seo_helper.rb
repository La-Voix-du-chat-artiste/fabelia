module SEOHelper
  def seo_meta_tags(pagy = nil)
    display_meta_tags site: 'Fabelia',
                      title: title_for_page,
                      description: description_for_page,
                      reverse: true,
                      charset: 'utf-8',
                      lang: I18n.locale,
                      prev: pagy ? pagy_prev_url(pagy) : nil,
                      next: pagy ? pagy_next_url(pagy) : nil,
                      image_src: asset_url('/banner.png'),
                      og: { \
                        title: :title,
                        site_name: :site,
                        description: :description,
                        image: asset_url('/logo.png'),
                        url: request.url
                      },
                      twitter: { \
                        card: 'summary',
                        title: :title,
                        description: :description,
                        image: asset_url('/logo.png'),
                        url: request.url
                      },
                      icon: [{ href: '/favicon.ico', type: 'image/ico' }],
                      viewport: 'width=device-width,initial-scale=1',
                      'turbo-cache-control': 'no-preview',
                      'original-page-title': title_for_page
  end

  private

  def title_for_page
    t('title', scope: [:seo, controller_name, action_name], default: default_title)
  end

  def description_for_page
    t('description', scope: [:seo, controller_name, action_name], default: default_description)
  end

  def default_title
    t('seo.default.title')
  end

  def default_description
    I18n.t('seo.default.description')
  end
end
