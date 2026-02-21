
-- Create storage bucket for site images
INSERT INTO storage.buckets (id, name, public) VALUES ('site-images', 'site-images', true);

-- Allow public read access
CREATE POLICY "Public read access for site images"
ON storage.objects FOR SELECT
USING (bucket_id = 'site-images');

-- Allow authenticated users to upload
CREATE POLICY "Authenticated users can upload site images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'site-images' AND auth.role() = 'authenticated');

-- Allow authenticated users to update
CREATE POLICY "Authenticated users can update site images"
ON storage.objects FOR UPDATE
USING (bucket_id = 'site-images' AND auth.role() = 'authenticated');

-- Allow authenticated users to delete
CREATE POLICY "Authenticated users can delete site images"
ON storage.objects FOR DELETE
USING (bucket_id = 'site-images' AND auth.role() = 'authenticated');

-- Create hero_images table
CREATE TABLE public.hero_images (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  image_url TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.hero_images ENABLE ROW LEVEL SECURITY;

-- Everyone can read hero images
CREATE POLICY "Anyone can view hero images"
ON public.hero_images FOR SELECT
USING (true);

-- Only authenticated users can manage
CREATE POLICY "Authenticated users can insert hero images"
ON public.hero_images FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update hero images"
ON public.hero_images FOR UPDATE
USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can delete hero images"
ON public.hero_images FOR DELETE
USING (auth.role() = 'authenticated');
