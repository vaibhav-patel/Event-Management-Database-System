CREATE SCHEMA event;
set search_path to event;

CREATE TABLE event.users
(
  user_id serial NOT NULL,
  user_email character(50) NOT NULL,
  user_fname character(50) NOT NULL,
  user_lname character(50),
  user_description character(1000),
  facebook_url character(1000),
  linkdin_url character(1000),
  CONSTRAINT users_pkey PRIMARY KEY (user_id )
)

CREATE TABLE event.roles
(
  role_no integer NOT NULL,
  role_name character(50) NOT NULL,
  CONSTRAINT roles_pkey PRIMARY KEY (role_no )
)

CREATE TABLE event.notifications
(
  recieved_at timestamp without time zone NOT NULL,
  notification_title character(50) NOT NULL,
  message character(1000) NOT NULL,
  action character(50) NOT NULL,
  has_read boolean NOT NULL,
  user_id integer NOT NULL,
  CONSTRAINT notifications_pkey PRIMARY KEY (recieved_at , user_id ),
  CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES event.users (user_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE event.complaints
(
  complaint_id serial NOT NULL,
  complaint_description character(1000) NOT NULL,
  priority integer NOT NULL,
  register_date timestamp without time zone NOT NULL,
  is_resolved boolean NOT NULL,
  user_id integer NOT NULL,
  CONSTRAINT complaints_pkey PRIMARY KEY (complaint_id ),
  CONSTRAINT complaints_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES event.users (user_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL
)


CREATE TABLE event.subjects
(
  subtopic character(100) NOT NULL,
  topic character(100) NOT NULL,
  CONSTRAINT subjects_pkey PRIMARY KEY (subtopic )
)

CREATE TABLE event.state
(
  state character(50) NOT NULL,
  country character(50) NOT NULL,
  CONSTRAINT state_pkey PRIMARY KEY (state )
)

CREATE TABLE event.city
(
  city character(50) NOT NULL,
  state character(50) NOT NULL,
  CONSTRAINT city_pkey PRIMARY KEY (city ),
  CONSTRAINT city_state_fkey FOREIGN KEY (state)
      REFERENCES event.state (state) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL
)


CREATE TABLE event.location
(
  place character(50) NOT NULL,
  city character(50) NOT NULL,
  CONSTRAINT location_pkey PRIMARY KEY (place , city ),
  CONSTRAINT location_city_fkey FOREIGN KEY (city)
      REFERENCES event.city (city) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL
)

CREATE TABLE event.tax
(
  tax_type integer NOT NULL,
  tax_rate integer NOT NULL,
  state character(50) NOT NULL,
  CONSTRAINT tax_pkey PRIMARY KEY (tax_type , state ),
  CONSTRAINT tax_state_fkey FOREIGN KEY (state)
      REFERENCES event.state (state) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL
)

CREATE TABLE event.event
(
  event_id serial NOT NULL,
  event_name character(50) NOT NULL,
  event_description character(1000),
  event_url character(50),
  event_email character(50) NOT NULL,
  event_start_time timestamp without time zone,
  event_end_time timestamp without time zone,
  place character(50),
  city character(50),
  CONSTRAINT event_pkey PRIMARY KEY (event_id ),
  CONSTRAINT event_place_fkey FOREIGN KEY (place, city)
      REFERENCES event.location (place, city) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL
)


CREATE TABLE event.event_requirements
(
  equipment_name character(50) NOT NULL,
  quantity integer,
  is_available boolean,
  event_id integer NOT NULL,
  CONSTRAINT event_requirements_pkey PRIMARY KEY (equipment_name , event_id ),
  CONSTRAINT event_requirements_event_id_fkey FOREIGN KEY (event_id)
      REFERENCES event.event (event_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)




CREATE TABLE event.call_for_papers
(
  announcement_date timestamp without time zone NOT NULL,
  announcement character(1000) NOT NULL,
  call_start_date timestamp without time zone,
  call_end_date timestamp without time zone,
  event_id integer NOT NULL,
  CONSTRAINT call_for_papers_pkey PRIMARY KEY (announcement , event_id ),
  CONSTRAINT call_for_papers_event_id_fkey FOREIGN KEY (event_id)
      REFERENCES event.event (event_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)



CREATE TABLE event.sessions
(
  session_id serial NOT NULL,
  sessons_title character(50) NOT NULL,
  sessons_subtitle character(50) NOT NULL,
  sessons_start_time timestamp without time zone,
  sessons_end_time timestamp without time zone,
  short_abstract character(500),
  long_abstract character(1000),
  language character(100),
  event_id integer NOT NULL,
  CONSTRAINT sessions_pkey PRIMARY KEY (session_id , event_id ),
  CONSTRAINT sessions_event_id_fkey FOREIGN KEY (event_id)
      REFERENCES event.event (event_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE event.tickets
(
  ticket_type character(50) NOT NULL,
  number_of_available_tickets integer,
  tickets_description character(1000),
  price double precision,
  event_id integer NOT NULL,
  CONSTRAINT tickets_pkey PRIMARY KEY (ticket_type , event_id ),
  CONSTRAINT tickets_event_id_fkey FOREIGN KEY (event_id)
      REFERENCES event.event (event_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE event.user_roles
(
  role_no integer NOT NULL,
  user_id integer NOT NULL,
  event_id integer NOT NULL,
  CONSTRAINT user_roles_pkey PRIMARY KEY (role_no , user_id , event_id ),
  CONSTRAINT user_roles_event_id_fkey FOREIGN KEY (event_id)
      REFERENCES event.event (event_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT user_roles_role_no_fkey FOREIGN KEY (role_no)
      REFERENCES event.roles (role_no) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES event.users (user_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE event.orders
(
  transaction_id serial NOT NULL,
  payment_method character(100) NOT NULL,
  orders_quantity integer NOT NULL,
  payment_details character(1000) NOT NULL,
  order_date timestamp without time zone NOT NULL,
  ticket_type character(50) NOT NULL,
  event_id integer NOT NULL,
  user_id integer NOT NULL,
  CONSTRAINT orders_pkey PRIMARY KEY (transaction_id ),
  CONSTRAINT orders_ticket_type_fkey FOREIGN KEY (ticket_type, event_id)
      REFERENCES event.tickets (ticket_type, event_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES event.users (user_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL
)

CREATE TABLE event.user_coupons
(
  code integer NOT NULL,
  user_id integer NOT NULL,
  event_id integer NOT NULL,
  CONSTRAINT user_coupons_pkey PRIMARY KEY (code , user_id , event_id ),
  CONSTRAINT user_coupons_event_id_fkey FOREIGN KEY (event_id)
      REFERENCES event.event (event_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT user_coupons_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES event.users (user_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)


CREATE TABLE event.event_subject
(
  event_id integer NOT NULL,
  subtopic character(100) NOT NULL,
  CONSTRAINT event_subject_pkey PRIMARY KEY (event_id , subtopic ),
  CONSTRAINT event_subject_event_id_fkey FOREIGN KEY (event_id)
      REFERENCES event.event (event_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT event_subject_subtopic_fkey FOREIGN KEY (subtopic)
      REFERENCES event.subjects (subtopic) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)


CREATE TABLE event.speakers
(
  speaker_description character(1000),
  speaker_organization character(50),
  is_arrived boolean,
  address character(1000),
  session_id integer NOT NULL,
  event_id integer NOT NULL,
  user_id integer NOT NULL,
  CONSTRAINT speakers_pkey PRIMARY KEY (session_id , event_id , user_id ),
  CONSTRAINT speakers_session_id_fkey FOREIGN KEY (session_id, event_id)
      REFERENCES event.sessions (session_id, event_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT speakers_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES event.users (user_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
)


CREATE TABLE event.sponsors
(
  sponsor_money double precision NOT NULL,
  sponsor_type character(50) NOT NULL,
  sponsor_description character(1000),
  sponsor_organization character(50),
  event_id integer NOT NULL,
  user_id integer NOT NULL,
  CONSTRAINT sponsors_pkey PRIMARY KEY (event_id , user_id ),
  CONSTRAINT sponsors_event_id_fkey FOREIGN KEY (event_id)
      REFERENCES event.event (event_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT sponsors_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES event.users (user_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE event.discounts
(
  code integer NOT NULL,
  value integer NOT NULL,
  type integer NOT NULL,
  is_active boolean,
  valid_from timestamp without time zone,
  valid_till timestamp without time zone,
  event_id integer NOT NULL,
  CONSTRAINT discounts_pkey PRIMARY KEY (code , event_id ),
  CONSTRAINT discounts_event_id_fkey FOREIGN KEY (event_id)
      REFERENCES event.event (event_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
)


CREATE TABLE event.session_location
(
  building_name character(50) NOT NULL,
  room_no integer NOT NULL,
  floor_no character(5) NOT NULL,
  session_id integer NOT NULL,
  event_id integer NOT NULL,
  CONSTRAINT session_location_pkey PRIMARY KEY (building_name , room_no , floor_no , session_id , event_id ),
  CONSTRAINT session_location_session_id_fkey FOREIGN KEY (session_id, event_id)
      REFERENCES event.sessions (session_id, event_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)