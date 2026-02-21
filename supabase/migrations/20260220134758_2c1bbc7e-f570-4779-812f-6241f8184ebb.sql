
-- Create enum for application status
CREATE TYPE public.app_status AS ENUM ('new', 'in_progress', 'completed', 'rejected');

-- Applications table
CREATE TABLE public.applications (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  parent_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  child_age TEXT,
  problem TEXT NOT NULL,
  preferred_time TEXT,
  comment TEXT,
  status app_status NOT NULL DEFAULT 'new',
  admin_comment TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.applications ENABLE ROW LEVEL SECURITY;

-- Public can insert (for the booking form)
CREATE POLICY "Anyone can submit applications"
ON public.applications FOR INSERT
WITH CHECK (true);

-- Only authenticated users (admin) can read
CREATE POLICY "Authenticated users can view applications"
ON public.applications FOR SELECT
TO authenticated
USING (true);

-- Only authenticated users can update
CREATE POLICY "Authenticated users can update applications"
ON public.applications FOR UPDATE
TO authenticated
USING (true);

-- Settings table for storing notification configs
CREATE TABLE public.notification_settings (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  provider TEXT NOT NULL UNIQUE,
  config JSONB NOT NULL DEFAULT '{}',
  enabled BOOLEAN NOT NULL DEFAULT false,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.notification_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can manage settings"
ON public.notification_settings FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

CREATE TRIGGER update_applications_updated_at
BEFORE UPDATE ON public.applications
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_settings_updated_at
BEFORE UPDATE ON public.notification_settings
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
