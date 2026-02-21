
-- Drop the restrictive policy
DROP POLICY IF EXISTS "Anyone can submit applications" ON public.applications;

-- Create a permissive policy instead
CREATE POLICY "Anyone can submit applications"
ON public.applications
FOR INSERT
TO anon, authenticated
WITH CHECK (true);
