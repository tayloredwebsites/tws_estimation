-- 050_assembly_components.sql

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

--DROP TABLE assembly_components;

CREATE TABLE assembly_components (
    id integer NOT NULL,
    component_id integer NOT NULL,
    assembly_id integer NOT NULL,
    description character varying(255) NULL,
    required boolean DEFAULT true NOT NULL,
    deactivated boolean DEFAULT false NOT NULL
);


--ALTER TABLE public.assembly_components OWNER TO postgres;

INSERT INTO assembly_components (id, component_id, assembly_id, description, required, deactivated) VALUES
(1, 4, 1, NULL, true, false),
(2, 5, 1, NULL, true, false),
(3, 6, 1, NULL, true, false),
(4, 7, 1, NULL, true, false),
(5, 8, 1, NULL, true, false),
(6, 6, 2, NULL, true, false),
(7, 17, 11, NULL, false, true),
(28, 52, 1, NULL, true, false),
(30, 11, 1, NULL, true, false),
(32, 10, 1, NULL, true, false),
(34, 12, 1, NULL, true, false),
(36, 18, 1, NULL, true, false),
(38, 23, 1, NULL, true, false),
(40, 25, 1, NULL, true, false),
(42, 19, 1, NULL, true, false),
(44, 32, 1, NULL, true, false),
(46, 36, 1, NULL, true, false),
(48, 35, 1, NULL, true, false),
(50, 28, 1, NULL, true, false),
(52, 26, 1, NULL, true, false),
(54, 52, 7, NULL, true, false),
(56, 45, 1, NULL, false, true),
(57, 55, 11, NULL, false, true),
(59, 55, 5, NULL, false, true),
(61, 41, 2, NULL, true, false),
(73, 56, 11, NULL, false, true),
(8, 17, 5, NULL, false, true),
(9, 17, 8, NULL, false, true),
(16, 17, 6, NULL, false, true),
(17, 17, 1, NULL, true, false),
(18, 17, 3, NULL, false, true),
(19, 17, 9, NULL, false, true),
(20, 17, 10, NULL, false, true),
(21, 17, 4, NULL, false, true),
(22, 17, 7, NULL, false, true),
(23, 17, 2, NULL, false, true),
(27, 43, 1, NULL, false, true),
(29, 13, 1, NULL, true, false),
(31, 15, 1, NULL, true, false),
(33, 16, 1, NULL, true, false),
(35, 14, 1, NULL, true, false),
(37, 20, 1, NULL, true, false),
(39, 22, 1, NULL, true, false),
(41, 24, 1, NULL, true, false),
(43, 21, 1, NULL, true, false),
(45, 34, 1, NULL, true, false),
(47, 29, 1, NULL, true, false),
(49, 33, 1, NULL, true, false),
(51, 30, 1, NULL, true, false),
(53, 31, 1, NULL, true, false),
(55, 52, 2, NULL, true, false),
(58, 55, 9, NULL, false, true),
(60, 55, 10, NULL, false, true),
(62, 10, 2, NULL, true, false),
(63, 16, 2, NULL, false, true),
(64, 4, 2, NULL, false, true),
(65, 22, 2, NULL, true, false),
(66, 25, 2, NULL, false, true),
(67, 48, 2, NULL, true, false),
(68, 19, 2, NULL, true, false),
(69, 35, 2, NULL, false, true),
(70, 33, 2, NULL, true, false),
(71, 28, 2, NULL, true, false),
(72, 30, 2, NULL, true, false),
(74, 56, 9, NULL, false, true),
(75, 56, 5, NULL, false, true),
(76, 56, 10, NULL, false, true),
(77, 56, 8, NULL, true, false),
(78, 56, 4, NULL, false, true),
(79, 56, 6, NULL, false, true),
(80, 56, 7, NULL, false, true),
(81, 56, 1, NULL, false, true),
(82, 56, 2, NULL, false, true),
(83, 56, 3, NULL, false, true),
(84, 57, 11, NULL, false, true),
(85, 57, 9, NULL, false, true),
(86, 57, 5, NULL, false, true),
(87, 57, 10, NULL, false, true),
(88, 57, 8, NULL, false, true),
(89, 57, 4, NULL, false, true),
(90, 57, 6, NULL, false, true),
(91, 57, 7, NULL, false, true),
(92, 57, 1, NULL, false, true),
(93, 57, 2, NULL, false, true),
(94, 57, 3, NULL, false, true),
(95, 58, 11, NULL, false, true),
(96, 58, 9, NULL, false, true),
(97, 58, 5, NULL, false, true),
(98, 58, 10, NULL, false, true),
(99, 58, 8, NULL, false, true),
(100, 58, 4, NULL, false, true),
(101, 58, 6, NULL, false, true),
(102, 58, 7, NULL, false, true),
(103, 58, 1, NULL, false, true),
(104, 58, 2, NULL, false, true),
(105, 58, 3, NULL, false, true),
(106, 52, 11, NULL, false, true),
(109, 54, 1, NULL, false, true),
(113, 59, 1, NULL, false, true),
(371, 85, 11, NULL, false, true),
(382, 3, 11, NULL, false, true),
(392, 86, 11, NULL, false, true),
(403, 85, 12, NULL, true, false),
(412, 52, 13, NULL, false, false),
(414, 54, 13, NULL, false, false),
(418, 7, 13, NULL, false, false),
(420, 47, 13, NULL, false, false),
(423, 38, 13, NULL, false, false),
(427, 79, 13, NULL, false, false),
(435, 63, 13, NULL, false, false),
(436, 64, 13, NULL, false, false),
(446, 12, 13, NULL, false, false),
(460, 24, 13, NULL, false, false),
(463, 21, 13, NULL, false, false),
(470, 29, 13, NULL, false, false),
(471, 80, 13, NULL, false, false),
(475, 33, 13, NULL, false, false),
(476, 28, 13, NULL, false, false),
(107, 52, 4, NULL, false, true),
(108, 52, 6, NULL, false, false),
(110, 2, 1, NULL, false, true),
(115, 61, 10, NULL, true, false),
(118, 63, 10, NULL, true, false),
(415, 17, 13, NULL, false, false),
(448, 37, 13, NULL, false, false),
(449, 14, 13, NULL, false, false),
(462, 19, 13, NULL, false, false),
(111, 1, 1, NULL, false, true),
(112, 3, 1, NULL, false, true),
(114, 60, 1, NULL, false, true),
(116, 62, 10, NULL, true, false),
(119, 64, 10, NULL, true, false),
(421, 42, 13, NULL, false, false),
(424, 6, 13, NULL, false, false),
(453, 77, 13, NULL, false, false),
(124, 44, 10, NULL, true, false),
(125, 65, 10, NULL, true, false),
(127, 66, 10, NULL, true, false),
(128, 67, 10, NULL, false, true),
(129, 68, 10, NULL, true, false),
(130, 69, 10, NULL, true, false),
(131, 70, 10, NULL, true, false),
(132, 71, 10, NULL, true, false),
(133, 72, 10, NULL, false, true),
(134, 73, 1, NULL, false, true),
(135, 74, 9, NULL, true, false),
(136, 75, 9, NULL, true, false),
(137, 20, 9, NULL, true, false),
(138, 20, 10, NULL, true, false),
(139, 76, 2, NULL, false, true),
(140, 76, 8, NULL, true, false),
(141, 77, 8, NULL, false, true),
(142, 78, 6, NULL, true, false),
(143, 79, 6, NULL, false, false),
(144, 80, 6, NULL, true, false),
(145, 81, 7, NULL, true, false),
(146, 82, 1, NULL, false, true),
(147, 83, 11, NULL, true, false),
(148, 53, 11, NULL, true, false),
(149, 54, 11, NULL, true, false),
(150, 7, 11, NULL, true, false),
(151, 11, 11, NULL, true, false),
(152, 38, 11, NULL, true, false),
(153, 65, 11, NULL, true, false),
(154, 66, 11, NULL, true, false),
(155, 44, 11, NULL, true, false),
(156, 39, 11, NULL, true, false),
(157, 15, 11, NULL, true, false),
(158, 63, 11, NULL, true, false),
(159, 64, 11, NULL, true, false),
(160, 45, 11, NULL, true, false),
(161, 62, 11, NULL, true, false),
(162, 14, 11, NULL, true, false),
(163, 18, 11, NULL, true, false),
(164, 20, 11, NULL, true, false),
(165, 22, 11, NULL, true, false),
(166, 19, 11, NULL, true, false),
(167, 21, 11, NULL, true, false),
(168, 51, 11, NULL, true, false),
(169, 34, 11, NULL, true, false),
(170, 80, 11, NULL, true, false),
(171, 70, 11, NULL, true, false),
(172, 69, 11, NULL, true, false),
(173, 33, 11, NULL, true, false),
(174, 28, 11, NULL, true, false),
(175, 26, 11, NULL, true, false),
(176, 31, 11, NULL, true, false),
(177, 71, 11, NULL, true, false),
(178, 2, 11, NULL, false, true),
(179, 1, 11, NULL, false, true),
(180, 59, 11, NULL, false, true),
(181, 60, 11, NULL, false, true),
(182, 74, 3, NULL, true, false),
(183, 7, 3, NULL, true, false),
(184, 38, 3, NULL, true, false),
(185, 65, 3, NULL, true, false),
(186, 66, 3, NULL, true, false),
(187, 44, 3, NULL, true, false),
(188, 39, 3, NULL, true, false),
(189, 45, 3, NULL, true, false),
(190, 75, 3, NULL, true, false),
(191, 46, 3, NULL, true, false),
(192, 40, 3, NULL, true, false),
(193, 41, 3, NULL, true, false),
(194, 14, 3, NULL, true, false),
(195, 18, 3, NULL, true, false),
(196, 51, 3, NULL, true, false),
(197, 34, 3, NULL, true, false),
(198, 70, 3, NULL, true, false),
(199, 69, 3, NULL, true, false),
(200, 33, 3, NULL, true, false),
(201, 28, 3, NULL, true, false),
(202, 31, 3, NULL, true, false),
(203, 71, 3, NULL, true, false),
(204, 2, 3, NULL, false, true),
(205, 1, 3, NULL, false, true),
(206, 59, 3, NULL, false, true),
(207, 60, 3, NULL, false, true),
(208, 12, 11, NULL, true, false),
(209, 7, 7, NULL, true, false),
(210, 13, 7, NULL, true, false),
(211, 11, 7, NULL, true, false),
(212, 39, 7, NULL, true, false),
(213, 10, 7, NULL, true, false),
(214, 12, 7, NULL, true, false),
(215, 8, 7, NULL, true, false),
(216, 14, 7, NULL, true, false),
(217, 20, 7, NULL, true, false),
(218, 22, 7, NULL, true, false),
(219, 19, 7, NULL, true, false),
(220, 21, 7, NULL, true, false),
(221, 32, 7, NULL, true, false),
(222, 34, 7, NULL, true, false),
(223, 29, 7, NULL, true, false),
(224, 35, 7, NULL, true, false),
(225, 33, 7, NULL, true, false),
(226, 28, 7, NULL, true, false),
(227, 30, 7, NULL, true, false),
(228, 26, 7, NULL, true, false),
(229, 31, 7, NULL, true, false),
(230, 2, 7, NULL, false, true),
(231, 1, 7, NULL, false, true),
(232, 59, 7, NULL, false, true),
(233, 60, 7, NULL, false, true),
(234, 54, 6, NULL, true, false),
(235, 7, 6, NULL, true, false),
(236, 11, 6, NULL, true, false),
(237, 44, 6, NULL, true, false),
(238, 15, 6, NULL, true, false),
(239, 63, 6, NULL, true, false),
(240, 64, 6, NULL, true, false),
(241, 12, 6, NULL, true, false),
(242, 14, 6, NULL, true, false),
(243, 20, 6, NULL, true, false),
(244, 22, 6, NULL, true, false),
(245, 19, 6, NULL, true, false),
(246, 21, 6, NULL, true, false),
(247, 34, 6, NULL, true, false),
(248, 35, 6, NULL, true, false),
(249, 69, 6, NULL, true, false),
(250, 33, 6, NULL, true, false),
(251, 26, 6, NULL, true, false),
(252, 2, 6, NULL, false, true),
(253, 1, 6, NULL, false, true),
(254, 59, 6, NULL, false, true),
(255, 60, 6, NULL, false, true),
(256, 43, 2, NULL, true, false),
(257, 7, 2, NULL, true, false),
(258, 47, 2, NULL, true, false),
(259, 42, 2, NULL, true, false),
(260, 38, 2, NULL, true, false),
(261, 13, 2, NULL, true, false),
(262, 11, 2, NULL, true, false),
(263, 44, 2, NULL, true, false),
(264, 39, 2, NULL, true, false),
(265, 15, 2, NULL, true, false),
(266, 45, 2, NULL, true, false),
(267, 46, 2, NULL, true, false),
(268, 40, 2, NULL, true, false),
(269, 12, 2, NULL, true, false),
(270, 8, 2, NULL, true, false),
(271, 37, 2, NULL, true, false),
(272, 14, 2, NULL, true, false),
(273, 18, 2, NULL, true, false),
(274, 20, 2, NULL, true, false),
(275, 23, 2, NULL, true, false),
(276, 50, 2, NULL, true, false),
(277, 49, 2, NULL, true, false),
(278, 24, 2, NULL, true, false),
(279, 21, 2, NULL, true, false),
(280, 32, 2, NULL, true, false),
(281, 51, 2, NULL, true, false),
(282, 34, 2, NULL, true, false),
(283, 36, 2, NULL, true, false),
(284, 29, 2, NULL, true, false),
(285, 26, 2, NULL, true, false),
(286, 31, 2, NULL, true, false),
(287, 2, 2, NULL, false, true),
(288, 1, 2, NULL, false, true),
(289, 59, 2, NULL, false, true),
(290, 60, 2, NULL, false, true),
(291, 43, 8, NULL, true, false),
(292, 42, 8, NULL, true, false),
(293, 38, 8, NULL, true, false),
(294, 44, 8, NULL, true, false),
(295, 45, 8, NULL, true, false),
(296, 46, 8, NULL, true, false),
(297, 40, 8, NULL, true, false),
(298, 41, 8, NULL, true, false),
(299, 50, 8, NULL, true, false),
(300, 49, 8, NULL, true, false),
(301, 48, 8, NULL, true, false),
(302, 19, 8, NULL, true, false),
(303, 21, 8, NULL, true, false),
(304, 51, 8, NULL, true, false),
(305, 33, 8, NULL, true, false),
(306, 28, 8, NULL, true, false),
(307, 30, 8, NULL, true, false),
(308, 2, 8, NULL, false, true),
(309, 1, 8, NULL, false, true),
(310, 59, 8, NULL, false, true),
(311, 60, 8, NULL, false, true),
(312, 7, 9, NULL, true, false),
(313, 38, 9, NULL, true, false),
(314, 65, 9, NULL, true, false),
(315, 66, 9, NULL, true, false),
(316, 44, 9, NULL, true, false),
(317, 39, 9, NULL, true, false),
(318, 45, 9, NULL, true, false),
(319, 46, 9, NULL, true, false),
(320, 40, 9, NULL, true, false),
(321, 41, 9, NULL, true, false),
(322, 14, 9, NULL, true, false),
(323, 18, 9, NULL, true, false),
(324, 68, 9, NULL, true, false),
(325, 22, 9, NULL, true, false),
(326, 50, 9, NULL, true, false),
(327, 48, 9, NULL, true, false),
(328, 19, 9, NULL, true, false),
(329, 21, 9, NULL, true, false),
(330, 51, 9, NULL, true, false),
(331, 34, 9, NULL, true, false),
(332, 36, 9, NULL, true, false),
(333, 70, 9, NULL, true, false),
(334, 69, 9, NULL, true, false),
(335, 33, 9, NULL, true, false),
(336, 28, 9, NULL, true, false),
(337, 31, 9, NULL, true, false),
(338, 71, 9, NULL, true, false),
(339, 2, 9, NULL, false, true),
(340, 1, 9, NULL, false, true),
(341, 59, 9, NULL, false, true),
(342, 60, 9, NULL, false, true),
(343, 7, 10, NULL, true, false),
(344, 38, 10, NULL, true, false),
(345, 45, 10, NULL, true, false),
(346, 14, 10, NULL, true, false),
(347, 18, 10, NULL, true, false),
(348, 22, 10, NULL, true, false),
(349, 19, 10, NULL, true, false),
(350, 21, 10, NULL, true, false),
(351, 51, 10, NULL, true, false),
(352, 34, 10, NULL, true, false),
(353, 33, 10, NULL, true, false),
(354, 28, 10, NULL, true, false),
(355, 31, 10, NULL, true, false),
(356, 2, 10, NULL, false, true),
(357, 1, 10, NULL, false, true),
(358, 59, 10, NULL, false, true),
(359, 60, 10, NULL, false, true),
(360, 13, 4, NULL, true, false),
(361, 2, 4, NULL, false, true),
(362, 1, 4, NULL, false, true),
(363, 59, 4, NULL, false, true),
(364, 60, 4, NULL, false, true),
(365, 7, 5, NULL, true, false),
(366, 22, 5, NULL, true, false),
(367, 2, 5, NULL, false, true),
(368, 1, 5, NULL, false, true),
(369, 59, 5, NULL, false, true),
(370, 60, 5, NULL, false, true),
(443, 10, 13, NULL, false, false),
(474, 69, 13, NULL, false, false),
(372, 85, 9, NULL, false, true),
(373, 85, 5, NULL, false, true),
(374, 85, 10, NULL, false, true),
(375, 85, 8, NULL, false, true),
(376, 85, 4, NULL, false, true),
(377, 85, 6, NULL, false, true),
(378, 85, 7, NULL, false, true),
(379, 85, 1, NULL, false, true),
(380, 85, 2, NULL, false, true),
(381, 85, 3, NULL, false, true),
(413, 53, 13, NULL, false, false),
(416, 74, 13, NULL, false, false),
(437, 45, 13, NULL, false, false),
(439, 75, 13, NULL, false, false),
(440, 46, 13, NULL, false, false),
(441, 40, 13, NULL, false, false),
(447, 8, 13, NULL, false, false),
(459, 49, 13, NULL, false, false),
(461, 48, 13, NULL, false, false),
(466, 51, 13, NULL, false, false),
(467, 34, 13, NULL, false, false),
(472, 35, 13, NULL, false, false),
(480, 71, 13, NULL, false, false),
(383, 3, 9, NULL, false, true),
(384, 3, 5, NULL, false, true),
(385, 3, 10, NULL, false, true),
(386, 3, 8, NULL, false, true),
(387, 3, 4, NULL, false, true),
(388, 3, 6, NULL, false, true),
(389, 3, 7, NULL, false, true),
(390, 3, 2, NULL, false, true),
(391, 3, 3, NULL, false, true),
(405, 2, 12, NULL, true, false),
(407, 3, 12, NULL, true, false),
(409, 59, 12, NULL, false, false),
(411, 56, 12, NULL, false, false),
(422, 76, 13, NULL, false, false),
(425, 13, 13, NULL, false, false),
(429, 66, 13, NULL, false, false),
(430, 44, 13, NULL, false, false),
(431, 78, 13, NULL, false, false),
(432, 39, 13, NULL, false, false),
(438, 62, 13, NULL, false, false),
(442, 41, 13, NULL, false, false),
(445, 4, 13, NULL, false, false),
(450, 61, 13, NULL, false, false),
(454, 23, 13, NULL, false, false),
(456, 22, 13, NULL, false, false),
(457, 25, 13, NULL, false, false),
(464, 9, 13, NULL, false, false),
(465, 32, 13, NULL, false, false),
(393, 86, 9, NULL, false, true),
(394, 86, 5, NULL, false, true),
(395, 86, 10, NULL, false, true),
(396, 86, 8, NULL, false, true),
(397, 86, 4, NULL, false, true),
(398, 86, 6, NULL, false, true),
(399, 86, 7, NULL, false, true),
(400, 86, 1, NULL, false, true),
(401, 86, 2, NULL, false, true),
(402, 86, 3, NULL, false, true),
(404, 86, 12, NULL, true, false),
(406, 1, 12, NULL, true, false),
(408, 60, 12, NULL, false, false),
(410, 57, 12, NULL, false, false),
(417, 43, 13, NULL, false, false),
(419, 5, 13, NULL, false, false),
(426, 11, 13, NULL, false, false),
(428, 65, 13, NULL, false, false),
(433, 15, 13, NULL, false, false),
(434, 81, 13, NULL, false, false),
(444, 16, 13, NULL, false, false),
(451, 18, 13, NULL, false, false),
(452, 20, 13, NULL, false, false),
(455, 68, 13, NULL, false, false),
(458, 50, 13, NULL, false, false),
(468, 36, 13, NULL, false, false),
(469, 83, 13, NULL, false, false),
(473, 70, 13, NULL, false, false),
(477, 30, 13, NULL, false, false),
(478, 26, 13, NULL, false, false),
(479, 31, 13, NULL, false, false);




-- DROP SEQUENCE assembly_components_seq;
CREATE SEQUENCE assembly_components_seq;
ALTER TABLE ONLY assembly_components
    ALTER COLUMN id SET DEFAULT NEXTVAL('assembly_components_seq'),
    ADD CONSTRAINT assembly_components_pk_assembly_components PRIMARY KEY (id),
    ADD CONSTRAINT fk_assembly_components_components FOREIGN KEY (component_id) REFERENCES components(id),
    ADD CONSTRAINT fk_assembly_components_assemblies FOREIGN KEY (assembly_id) REFERENCES assemblies(id);



