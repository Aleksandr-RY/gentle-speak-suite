
-- Work schedule: stores working hours per day of week (0=Sunday, 6=Saturday)
CREATE TABLE public.work_schedule (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    day_of_week integer NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
    start_time time NOT NULL DEFAULT '10:00',
    end_time time NOT NULL DEFAULT '18:00',
    is_working_day boolean NOT NULL DEFAULT true,
    slot_duration_minutes integer NOT NULL DEFAULT 45,
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    UNIQUE (day_of_week)
);

ALTER TABLE public.work_schedule ENABLE ROW LEVEL SECURITY;

-- Anyone can read schedule (needed for booking form)
CREATE POLICY "Anyone can view schedule"
ON public.work_schedule FOR SELECT
USING (true);

-- Only admins can manage schedule
CREATE POLICY "Admins can manage schedule"
ON public.work_schedule FOR ALL
TO authenticated
USING (public.has_role(auth.uid(), 'admin'))
WITH CHECK (public.has_role(auth.uid(), 'admin'));

-- Seed default schedule (Mon-Fri 10:00-18:00, Sat-Sun off)
INSERT INTO public.work_schedule (day_of_week, start_time, end_time, is_working_day) VALUES
(0, '10:00', '18:00', false),  -- Sunday
(1, '10:00', '18:00', true),   -- Monday
(2, '10:00', '18:00', true),   -- Tuesday
(3, '10:00', '18:00', true),   -- Wednesday
(4, '10:00', '18:00', true),   -- Thursday
(5, '10:00', '18:00', true),   -- Friday
(6, '10:00', '18:00', false);  -- Saturday
